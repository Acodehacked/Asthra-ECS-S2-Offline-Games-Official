extends Node

var COLLECTION_ID = "gamers"
var high_score: int
var score: int = 0
var game_running: bool = false
var selected_time = false
var question1 = {
	"question": "What is wrong with this Python code?",
	"code": "x = 10\ny = 0\nprint(x / y)",
	"options": [
		"Nothing is wrong",
		"Division by zero error",
		"Syntax error",
		"Print statement is incorrect"
	],
	"correct_index": 1,
	"language": "Python"
}

var question2 = {
	"question": "What will this Python loop output?",
	"code": "for i in range(3, 3):\n    print(i)",
	"options": [
		"It prints 3",
		"It prints 3, 2, 1",
		"It does nothing",
		"Syntax error"
	],
	"correct_index": 2,
	"language": "Python"
}

var question3 = {
	"question": "What is wrong with this Python function?",
	"code": "def add(a, b):\n    result = a + b\nprint(add(2, 3))",
	"options": [
		"Nothing is wrong",
		"Function must return a value",
		"Incorrect print syntax",
		"Incorrect function parameters"
	],
	"correct_index": 1,
	"language": "Python"
}

var question4 = {
	"question": "What will this Python code output?",
	"code": "x = [1, 2, 3]\nprint(x[3])",
	"options": [
		"1",
		"IndexError",
		"None",
		"3"
	],
	"correct_index": 1,
	"language": "Python"
}

var question5 = {
	"question": "What is the issue in this program?",
	"code": "count = 0\nwhile count < 5:\n    print(count)",
	"options": [
		"Nothing is wrong",
		"Infinite loop",
		"Syntax error",
		"Missing print statement"
	],
	"correct_index": 1,
	"language": "Python"
}

var quiz_data = [question1, question2, question3, question4, question5];



var current_question_index: int = 0
@onready var question_label = $QuestionLabel
@onready var option_buttons = [$Option1, $Option2, $Option3, $Option4]

func _ready():
	new_game()
	$GameOver.hide()
	load_question()
	
	var user_data = UserData.load_or_create()
	$Hud.get_node("UserNameLabel").text = user_data.name
	high_score = user_data.game_1

func new_game():
	score = 0
	show_score()
	get_tree().paused = false
	
	# Reset HUD
	$Hud.get_node("StartLabel").show()
	$Hud.get_node("Useless0").show()
	$Hud.get_node("Useless1").show()
	$GameOver.hide()

func _process(delta):
	if not game_running:
		if Input.is_action_just_pressed("ui_accept"):
			start_game()

func _on_next_button_pressed() -> void:
	next_question()

func start_game():
	$Hud.get_node("Useless0").hide()
	$Hud.get_node("Useless1").hide()
	$Hud.get_node("Useless2").hide()
	$Hud.get_node("StartLabel").hide()
	game_running = true

func load_question():
	show_score()
	var question_data = quiz_data[current_question_index]
	question_label.text = question_data["question"]
	$CodeLabel.text = question_data["code"]
	$CodeTypeLabel.text = "Language: " + question_data["language"]
	
	for i in range(option_buttons.size()):
		option_buttons[i].text = question_data["options"][i]
		option_buttons[i].modulate = Color(1, 1, 1, 1)
		option_buttons[i].pressed.connect(_on_option_selected.bind(i))

func _on_option_selected(selected_index):
	if selected_time:
		return
	selected_time = true
	
	if current_question_index >= quiz_data.size():
		return
	
	var correct_index = quiz_data[current_question_index]["correct_index"]
	if selected_index == correct_index:
		option_buttons[selected_index].modulate = Color(0, 1, 0, 1)
		score += 1
		show_score()
	else:
		option_buttons[selected_index].modulate = Color(1, 0, 0, 1)
		option_buttons[correct_index].modulate = Color(0, 1, 0, 1)

func next_question():
	selected_time = false
	current_question_index += 1
	print("size: "+str(quiz_data.size()))
	print("current question: "+str(current_question_index))
	if current_question_index < quiz_data.size():
		load_question()
	else:
		game_over()

func show_score():
	$Hud.get_node("ScoreLabel").text = "SCORE: " + str(score)

func game_over():
	#get_tree().paused = true
	$GameOver.get_node("HomeButton").hide()
	$GameOver.show()
	var user = UserData.load_or_create()
	var userText = $GameOver.get_node("UserTextLabel")
	var userScore = $GameOver.get_node("UserScoreLabel")
	var overTitle = $GameOver.get_node("TitleLabel")
	var loadingLabel = $GameOver.get_node("LoadingLabel")

	if score < 1:
		overTitle.text = "Sorry!"
		userText.text = "Hi " + user.name + ", Unfortunately, you are not eligible for the leaderboard. But we're glad to have you on board!"
	else:
		save_game()
		overTitle.text = "Congrats!"
		userText.text = "Hi " + user.name + ", Congratulations! You are eligible for the leaderboard. We're thrilled to have you on board!"
		loadingLabel.text = "Please wait... Saving to the cloud."
		#userText.text = "Hi " + user.name + ", Congratulations! You’ve made it to the leaderboard! 🚀"

func save_game():
	var user = UserData.load_or_create()
	var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
	var document: FirestoreDocument = await collection.get_doc(user.user_id)
	var loadingLabel = $GameOver.get_node("LoadingLabel")
	
	var s = user.game_1 + user.game_2 + user.game_3 + user.game_4
	if document:
		document.add_or_update_field("trophies", s)
		document.add_or_update_field("game_1", user.game_1)
		document.add_or_update_field("game_2", user.game_2)
		document.add_or_update_field("game_3", user.game_3)
		document.add_or_update_field("game_4", user.game_4)
		document = await collection.update(document)
		
		if document:
			loadingLabel.text = "Saved to Cloud"
			on_saved_game()
	else:
		loadingLabel.text = "Failed to save"

func on_saved_game():
	var home_btn = $GameOver.get_node("HomeButton")
	home_btn.show()
	home_btn.pressed.connect(go_home)

func go_home():
	get_tree().change_scene_to_file("res://Home.tscn")
