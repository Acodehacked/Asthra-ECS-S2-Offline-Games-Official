class_name Time_Manager extends Node

var time_left: float = 0.0  # 20 minutes in seconds
var timer_running: bool = false
var save_timer: float = 0.0 

func _process(delta):
	if timer_running and time_left > 0:
		time_left -= delta
		save_timer += delta  # Accumulate elapsed time
		
		# Save every 1 second
		if save_timer >= 1.0:
			save_timer = 0  # Reset accumulator
			save_time_left()

	elif time_left <= 0 and timer_running:
		time_left = 0
		timer_running = false
		save_time_left() 
		time_left = 0 # Ensure final save when time hits 0
		change_to_timeout_scene()

func save_time_left():
	var user = UserData.load_or_create()
	user.time_left = time_left
	user.save()

func start_timer():
	var user = UserData.load_or_create()
	if user.time_left <= 0:
		user.time_left = 1200  # Default time if not set
	user.save()  # Save the new value immediately

	time_left = user.time_left  # Update the time_left variable
	timer_running = true
	print("Timer started with time left:", time_left)

func reset_timer():
	var user = UserData.load_or_create()
	user.time_left = 1200
	user.save()  # Save the new value immediately
	time_left =  1200
	timer_running = true
	print("Timer started with time left:", time_left)


func get_time_left() -> float:
	return time_left
	
func get_formatted_time() -> String:
	var minutes = int(time_left / 60)  # Correct integer division
	var seconds = int(time_left) % 60
	return "%02d:%02d" % [minutes, seconds]

func change_to_timeout_scene():
	if get_tree().current_scene:
		print("Current scene:", get_tree().current_scene.scene_file_path)
	else:
		print("Current scene: None")

	print("Attempting to change to TimeOut.tscn...")
	var result = get_tree().change_scene_to_file("res://TimOut.tscn")
	
	if result != OK:
		print("Scene change failed! Error code:", result)
	else:
		print("Scene change successful!")
