extends Node

# Preload obstacles

var high_score:int;
var score:int = 0;
var game_running:bool= false
var quiz_data = [
	{
		"question": "What is the capital of France?",
		"options": ["Berlin", "Paris", "Madrid", "Rome"],
		"correct_index": 1
	},
	{
		"question": "Which planet is known as the Red Planet?",
		"options": ["Earth", "Mars", "Jupiter", "Saturn"],
		"correct_index": 1
	}
]
var current_question_index:int = 0
@onready var question_label = $QuestionLabel
@onready var option_buttons = [$Option1, $Option2, $Option3, $Option4]
#onready var feedback_label = $FeedbackLabel
#var ground_texture_width = $Ground.get_node("Sprite2D").texture.get_width() * $Ground.get_node("Sprite2D").scale.x
# Called when the node enters the scene tree for the first time.
func _ready():
	#$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()
	$GameOver.hide()
	load_question()
	var user_data = UserData.load_or_create()
	$Hud.get_node("UserNameLabel").text = user_data.name
	high_score = user_data.game_1

func new_game():
	# Reset variables
	score = 0
	
	show_score()
	get_tree().paused = false
	
	# Reset HUD and game over screen
	$Hud.get_node("StartLabel").show()
	$Hud.get_node("Useless0").show()
	$Hud.get_node("Useless1").show()
	$Hud.get_node("Useless1").show()
	$GameOver.hide()

# Called every frame
func _process(delta):
	if not game_running:
		if Input.is_action_just_pressed("ui_accept"):  # Use just_pressed to prevent auto-start
			start_game()
	
func start_game():
	$Hud.get_node("Useless0").hide()
	$Hud.get_node("Useless1").hide()
	$Hud.get_node("Useless2").hide()
	$Hud.get_node("StartLabel").hide()
	game_running = true

func load_question():
	var question_data = quiz_data[current_question_index]
	question_label.text = question_data["question"]
	
	for i in range(option_buttons.size()):
		option_buttons[i].text = question_data["options"][i]
		option_buttons[i].modulate = Color(1,1,1,1)  # Reset color to default
		#option_buttons[i].connect("pressed", self, "_on_option_selected", [i])
		option_buttons[i].pressed.connect(_on_option_selected.bind(i)) 

func _on_option_selected(selected_index):
	var correct_index = quiz_data[current_question_index]["correct_index"]

	if selected_index == correct_index:
		option_buttons[selected_index].modulate = Color(0, 1, 0, 1)  # Green for correct
		#feedback_label.text = "Correct!"
	else:
		option_buttons[selected_index].modulate = Color(1, 0, 0, 1)  # Red for wrong
		option_buttons[correct_index].modulate = Color(0, 1, 0, 1)  # Show correct answer in green
		#feedback_label.text = "Wrong!"

func next_question():
	current_question_index += 1
	if current_question_index < quiz_data.size():
		load_question()
	else:
		$GameOver.show()
		#feedback_label.text = "Quiz Completed!"

func show_score():
	$Hud.get_node("ScoreLabel").text = "SCORE: " + str(score)

func game_over():
	get_tree().paused = true
	$GameOver.show()
