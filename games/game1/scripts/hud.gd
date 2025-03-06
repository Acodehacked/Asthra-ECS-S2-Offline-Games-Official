extends Control

@onready var score = $Score:
	set(value):
		score.text = "Score: " + str(value)

#
@onready var time = $Time:
	set(value):
		time.text = "Time Left: " + str(value)


func _process(delta: float) -> void:
	time = Timer_Manager.get_formatted_time()	
