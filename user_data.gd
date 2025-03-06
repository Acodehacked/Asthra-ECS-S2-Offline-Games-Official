extends Resource
class_name UserData

@export var user_id: String = ""
@export var name: String = ""
@export var score: int = 0
@export var game_1: int = 0
@export var game_2: int = 0
@export var game_3: int = 0
@export var game_4: int = 0
@export var time_left: int = 1200

# Set a unique resource path so it can be saved
const SAVE_PATH = "user://user_data.tres"

func save():
	ResourceSaver.save(self, SAVE_PATH)

# Static function to load existing user data or create a new one
static func load_or_create():
	if FileAccess.file_exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH) as UserData
	else:
		var new_data = UserData.new()
		new_data.save()
		return new_data


func logout():
	# Remove saved user data file
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

	# Reset user data to default values
	user_id = ""
	name = ""
	score = 0
	game_1 = 0
	game_2 = 0
	game_3 = 0
	game_4 = 0
	time_left = 100
	
	# Save the reset state
	save()
