extends Control

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func set_score(value):
	$Panel/Score.text = "Score: " + str(value)

func set_high_score(value):
	$Panel/HighScore.text = "Requirement: " + str(value)

func set_high(value):
	$Panel/HighScore2.text = "Highscore: " + str(value)

func set_status(value:int):
	if value ==0:
		$Panel/ContinueBtn.hide()
		$Panel/GameOver.text = "Level 1 Failed"
	else:
		$Panel/GameOver.text = "Level 1 Passed"

func _on_home_btn_pressed() -> void:
		get_tree().change_scene_to_file("res://Games.tscn")


func _on_continue_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Games.tscn")
