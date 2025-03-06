extends Node2D




	 # Replace with function body.


func _on_button_2_pressed() -> void:
	var user = UserData.load_or_create()
	user.logout()
	get_tree().change_scene_to_file("res://Home.tscn")
