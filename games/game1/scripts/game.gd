extends Node2D

@export var enemy_scenes: Array[PackedScene] = [preload("res://games/game1/scenes/enemy.tscn"),preload("res://games/game1/scenes/diver_enemy.tscn")]

@onready var player_spawn_pos = $PlayerSpawnPos
@onready var laser_container = $LaserContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverScreen
@onready var pb = $ParallaxBackground

@onready var laser_sound = $SFX/LaserSound
@onready var hit_sound = $SFX/HitSound
@onready var explode_sound = $SFX/ExplodeSound
var REQUIRED = 750

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score

var scroll_speed = 800
var high_score:int =0
var game_running

func _ready():
	game_running = false
	$EnemySpawnTimer.paused = true
	hud.get_node("Instructions").show()
	var user = UserData.load_or_create()
	high_score = user.game_1
	gos.set_high_score(REQUIRED)
	MusicManager.stop_music()
	score = 0
	player = get_tree().get_first_node_in_group("player")
	assert(player!=null)
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)



func _process(delta):
	if game_running:
		start_game(delta)
	else:
		if Input.is_action_just_pressed("ui_accept"):
			$EnemySpawnTimer.paused = false
			game_running = true # Use just_pressed to prevent auto-start
			hud.get_node("Instructions").hide()
	#if Input.is_action_just_pressed("quit"):
		#get_tree().quit()
	#elif Input.is_action_just_pressed("reset"):
		#get_tree().reload_current_scene()
	
func start_game(delta):
	if timer.wait_time > 0.5:
		timer.wait_time -= delta*0.005
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5
	
	pb.scroll_offset.y += delta*scroll_speed
	if pb.scroll_offset.y >= 960:
		pb.scroll_offset.y = 0

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
	laser_sound.play()

func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(300, 1600), -50)
	e.killed.connect(_on_enemy_killed)
	e.hit.connect(_on_enemy_hit)
	enemy_container.add_child(e)

func _on_enemy_killed(points):
	hit_sound.play()
	score += points

func _on_enemy_hit():
	hit_sound.play()

func _on_player_killed():
	explode_sound.play()
	var user = UserData.load_or_create()
	if(score > user.game_1):
		user.game_1 = score
		user.save()
		high_score = score
	gos.set_high(high_score)
	gos.set_score(score)
	if(high_score >= REQUIRED):
		gos.set_status(1)
	else:
		gos.set_status(0)
	#save_game()
	await get_tree().create_timer(1.5).timeout
	gos.visible = true
