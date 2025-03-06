extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var user = UserData.load_or_create()
	$UserNameLabel.text = user.name

func set_score(value):
	$ScoreLabel.text = "SCORE: "+str(value)
	$PointSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TimeLabel.text = "Time Left: "+Timer_Manager.get_formatted_time()
