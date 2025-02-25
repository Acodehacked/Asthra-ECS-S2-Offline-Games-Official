extends Node2D

@onready var Startbtn = $StartBtn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Startbtn.connect("pressed",_on_button_pressed)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://loginPage.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_btn_pressed() -> void:
	pass # Replace with function body.
