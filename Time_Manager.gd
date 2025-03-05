class_name Time_Manager extends Node

var time_left: float = 20 * 60  # 20 minutes in seconds
var timer_running: bool = false

func _process(delta):
	if timer_running and time_left > 0:
		time_left -= delta
	elif time_left <= 0:
		timer_running = false  # Stop the timer when it reaches 0

func start_timer():
	var time_left: float = 20 * 60  # 20 minutes in seconds
	timer_running = true

func get_time_left() -> float:
	return time_left
	
func get_formatted_time() -> String:
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	return "%02d:%02d" % [minutes, seconds]
