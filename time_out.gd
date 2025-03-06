extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var user = UserData.load_or_create()
	user.logout()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_home_pressed() -> void:
	var user = UserData.load_or_create()
	user.logout()
	get_tree().change_scene_to_file("res://Home.tscn")
