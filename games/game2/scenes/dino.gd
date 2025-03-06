extends CharacterBody2D

const GRAVITY : int = 4200
const JUMP_SPEED : int = -1800
const FAST_FALL_GRAVITY : int = 8000  # Increased gravity for fast fall
@onready var JumpSound = $JumpSound

func _physics_process(delta):
	# Apply normal gravity
	velocity.y += GRAVITY * delta

	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
		else:
			$RunCol.disabled = false
			if Input.is_action_just_pressed("ui_accept"):  # Detect jump press
				velocity.y = JUMP_SPEED
				JumpSound.play()  
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite2D.play("duck")
				$RunCol.disabled = true
			else:
				$AnimatedSprite2D.play("run")
	else:
		# If player presses down while in the air, increase gravity (fast fall)
		if Input.is_action_pressed("ui_down"):
			velocity.y += FAST_FALL_GRAVITY * delta
			$AnimatedSprite2D.play("slide")  # Add a slide animation if available
		else:
			$AnimatedSprite2D.play("jump")

	move_and_slide()
