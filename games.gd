extends Control


@onready var HomeBtn = $HomeButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HomeBtn.connect("pressed",_on_home_btn_pressed)

func _on_home_btn_pressed():
	get_tree().change_scene_to_file("res://Home.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
