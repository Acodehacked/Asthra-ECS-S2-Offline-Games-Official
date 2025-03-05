extends Node

# Preload obstacles
var stump_scene = preload("res://games/game2/scenes/stump.tscn")
var rock_scene = preload("res://games/game2/scenes/rock.tscn")
var barrel_scene = preload("res://games/game2/scenes/barrel.tscn")
var bird_scene = preload("res://games/game2/scenes/bird.tscn")
var obstacle_types := [stump_scene, rock_scene, barrel_scene]
var obstacles : Array
var bird_heights := [200, 390]

# Game variables
const DINO_START_POS := Vector2i(349, 845)
const CAM_START_POS := Vector2i(993, 534)
var difficulty
const MAX_DIFFICULTY : int = 2
var score : int
const SCORE_MODIFIER : int = 30
var high_score : int
var speed : float
const START_SPEED : float = 5.0
const MAX_SPEED : int = 16
const SPEED_MODIFIER : int = 50000
var screen_size : Vector2i
var ground_height : int
var game_running : bool = false  # Ensure it starts as false
var last_obs
#var ground_texture_width = $Ground.get_node("Sprite2D").texture.get_width() * $Ground.get_node("Sprite2D").scale.x
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()

func new_game():
	# Reset variables
	score = 0
	show_score()
	game_running = false
	get_tree().paused = false
	difficulty = 0
	
	# Delete all obstacles
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	# Reset the nodes
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2.ZERO  # Ensure Dino is not moving
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(-30, 47)
	
	# Reset HUD and game over screen
	$HUD.get_node("StartLabel").show()
	$HUD.get_node("Useless0").show()
	$HUD.get_node("Useless1").show()
	$HUD.get_node("Useless1").show()
	$GameOver.hide()

# Called every frame
func _process(delta):
	if game_running:
		# Speed up and adjust difficulty
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		
		# Generate obstacles
		generate_obs()
		
		# Move dino and camera together
		var movement = speed / 6
		$Dino.position.x += movement
		$Camera2D.position.x += movement  # Ensure they move at the same speed
		
		# Update score
		score += speed / 5
		show_score()
		
		# Update ground position
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.43:
			$Ground.position.x += screen_size.x

		# Remove obstacles that have gone off screen
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		if Input.is_action_just_pressed("ui_accept"):  # Use just_pressed to prevent auto-start
			start_game()

func start_game():
	game_running = true
	$HUD.get_node("Useless0").hide()
	$HUD.get_node("Useless1").hide()
	$HUD.get_node("Useless2").hide()
	$HUD.get_node("StartLabel").hide()

func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = difficulty + 1
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x : int = screen_size.x + score + 100 + (i * 100)
			var obs_y : int = screen_size.y - (ground_height*1.2) - (obs_height * obs_scale.y / 2) + 5
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
		# Additionally random chance to spawn a bird
		if difficulty == MAX_DIFFICULTY:
			if (randi() % 2) == 0:
				obs = bird_scene.instantiate()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = bird_heights[randi() % bird_heights.size()]
				add_obs(obs, obs_x, obs_y)

func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body):
	if body.name == "Dino":
		game_over()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / SCORE_MODIFIER)

func check_high_score():
	if score > high_score:
		high_score = score
		$HUD.get_node("HighScoreLabel").text = "HIGH SCORE: " + str(high_score / SCORE_MODIFIER)

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func game_over():
	check_high_score()
	get_tree().paused = true
	game_running = false
	$GameOver.show()
