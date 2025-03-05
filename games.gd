extends Control


@onready var HomeBtn = $HomeButton
@onready var UserName = $UserTitle
@onready var scoreTitle = $UserTitle
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var user_data = UserData.load_or_create()
	Timer_Manager.start_timer()
	UserName.text = user_data.name
	
	HomeBtn.connect("pressed",_on_home_btn_pressed)

func _on_home_btn_pressed():
	pass
	#get_tree().change_scene_to_file("res://Home.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var get_formatted_time = Timer_Manager.get_formatted_time()
	#print("Time Left: ", get_formatted_time)
	$TimeLeftLabel.text = "Tme Left : "+str(get_formatted_time)

func _on_game_1_button_pressed() -> void:
	print('Hello')
#
#
#func _on_game_1_button_3_pressed() -> void:
	#print("Clicked")
	#get_tree().change_scene_to_file("res://games/game1/scenes/game.tscn")


func _on_game_1_button_3_pressed() -> void:
	pass # Replace with function body.
