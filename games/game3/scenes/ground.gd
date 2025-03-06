extends Area2D

signal hit

func _on_body_entered(body):
	get_parent().bird_hit()
	hit.emit()
