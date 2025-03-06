extends Node

@export var pipe_scene : PackedScene

var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : float = 0.3  # Reduced speed
var ground_height : int
var pipes:Array
var high_score = 0
const PIPE_DELAY : int = 0  # Initial delay for pipes
var pipe_range : int = 80  # Dynamic range for difficulty scaling
var screen_size : Vector2i
var REQUIRED = 50
# Called when the node enters the scene tree for the first time.
func _ready():
	var user = UserData.load_or_create()
	high_score = user.game_3
	MusicManager.stop_music()
	if pipe_scene == null:
		pipe_scene = load("res://games/game3/scenes/pipe.tscn")
	screen_size = get_window().size
	$HUD.get_node("Useless0").show()
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	$PipeTimer.wait_time = 1  # Increase wait time for slower pipes
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	pipe_range = 80  # Reset to initial easy mode
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	$Bird.reset()

func _input(event):
	if not game_over and Input.is_action_pressed("ui_accept"):
		if not game_running:
			start_game()
		else:
			if $Bird.flying:
				$Bird.flap()
				check_top()

func start_game():
	$HUD.get_node("Useless0").hide()
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$PipeTimer.start()

func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

func _on_pipe_timer_timeout():
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-pipe_range, pipe_range)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
	# Gradually increase difficulty by increasing pipe variation
	if score % 5 == 0 and pipe_range < 160:
		pipe_range += 10

func scored():
	score += 1
	$HUD.set_score(score)
	#$ScoreLabel.text = "SCORE: " + str(score)

func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game():
	var user = UserData.load_or_create()
	if score > high_score:
		high_score = score
		user.game_3 = high_score
		user.save()
	if high_score >= REQUIRED:
		$GameOver.set_status(1)
	else:
		$GameOver.set_status(0)
	$GameOver.set_score(score)
	$GameOver.set_high_score(REQUIRED)
	$GameOver.set_high(high_score)
	
	$PipeTimer.stop()
	$GameOver.show()
	$Bird.flying = false
	game_running = false
	game_over = true
	
func bird_hit():
	$Bird.falling = true
	stop_game()

# Fix ground collision detection
func _on_ground_hit():
	if game_running and not game_over:
		$Bird.falling = false
		stop_game()

func _on_game_over_restart():
	new_game()
