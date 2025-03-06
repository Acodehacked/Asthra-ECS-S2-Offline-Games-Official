extends Node2D



func set_requirement(value):
	$Panel/Requirement.text = "Requirement : " + str(value)


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
