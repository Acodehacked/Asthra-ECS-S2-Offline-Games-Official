extends Node2D

@onready var Startbtn = $StartBtn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Startbtn.connect("pressed",_on_button_pressed)
	MusicManager.play_music("res://assets/bg.ogg")  # Play a specific song

func _on_button_pressed():
	var user_data = UserData.load_or_create()
	if user_data.user_id =="":
		get_tree().change_scene_to_file("res://loginPage.tscn")
	else:
		Timer_Manager.start_timer()
		get_tree().change_scene_to_file("res://Games.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_btn_pressed() -> void:
	pass # Replace with function body.
