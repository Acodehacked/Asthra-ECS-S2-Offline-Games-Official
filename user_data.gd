extends Resource
class_name UserData

@export var user_id: String = ""

# Set a unique resource path so it can be saved
const SAVE_PATH = "user://user_data.tres"

# Save function
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
