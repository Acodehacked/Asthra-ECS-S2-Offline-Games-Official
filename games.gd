extends Control


#@onready var HomeBtn = $HomeButton
@onready var UserName = $UserTitle
@onready var scoreTitle = $UserTitle
@onready var notEligible = $CompleteLevel

var minMark = [0,750,1000,50]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	notEligible.hide()
	$LockedButton1.show()
	MusicManager.run_music()
	$LockedButton2.show()
	$LockedButton3.show()
	$Instructions.hide()
	$Instructions.get_node("HomeBtn").connect("pressed",close_instrt)
	var user_data = UserData.load_or_create()
	UserName.text = user_data.name
	$UserTotalScore.text = str(user_data.game_1 + user_data.game_2 + user_data.game_3 + user_data.game_4)
	if user_data.game_1 > minMark[1]:
		$LockedButton1.hide()
	if user_data.game_2 > minMark[2]:
		$LockedButton2.hide()
	if user_data.game_3 > minMark[3]:
		$LockedButton3.hide() 
	$Logout.hide()
	$Logout.get_node("Button").connect("pressed",closed)

func close_instrt():
	$Instructions.hide()

func closed():
	$Logout.hide()
func _on_home_btn_pressed():
	pass
	#get_tree().change_scene_to_file("res://Home.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var get_formatted_time = Timer_Manager.get_formatted_time()
	#print("Time Left: ", get_formatted_time)
	$TimeLeftLabel.text = "Tme Left : "+str(get_formatted_time)

func _on_game_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://games/game1/scenes/game.tscn")
#
#
#func _on_game_1_button_3_pressed() -> void:
	#print("Clicked")
	#get_tree().change_scene_to_file("res://games/game1/scenes/game.tscn")


func _on_game_2_button_pressed() -> void:
	var user_data = await UserData.load_or_create()
	if (user_data.game_1 >= minMark[1]):
		MusicManager.stop_music()
		get_tree().change_scene_to_file("res://games/game2/scenes/main.tscn")
	else:
		notEligible.set_requirement(minMark[1])
		notEligible.show()

func _on_game_3_button_pressed() -> void:
	var user_data = await UserData.load_or_create()
	if (user_data.game_2 >= minMark[2]):
		MusicManager.stop_music()
		get_tree().change_scene_to_file("res://games/game3/scenes/main.tscn")
	else:
		notEligible.set_requirement(minMark[2])
		notEligible.show()


func _on_game_4_button_pressed() -> void:
	var user_data = await UserData.load_or_create()
	if (user_data.game_3 >= minMark[3]):
		MusicManager.stop_music()
		get_tree().change_scene_to_file("res://games/game4/main.tscn")
	else:
		notEligible.set_requirement(minMark[3])
		notEligible.show()


func _on_logout_btn_pressed() -> void:
	$Logout.show()


func _on_instructions_button_pressed() -> void:
	$Instructions.show()
