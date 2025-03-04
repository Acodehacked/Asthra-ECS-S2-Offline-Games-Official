extends Control

@onready var loginBtn = $Button
var save_path = 'res://db.tres'
var COLLECTION_ID = "gamers"
var points:int = 0:
	set(value):
		points = value
# Called when the wnode enters the scene tree for the first time.
func _ready() -> void:
	loginBtn.connect("pressed",_on_login)
	Firebase.Auth.signup_failed.connect(_on_signup_succeeded)
	Firebase.Auth.signup_succeeded.connect(_on_signup_succeeded)
	Firebase.Auth.login_succeeded.connect(_on_login_succeeded)
	Firebase.Auth.login_failed.connect(_on_login_failed)

func _on_login():
	var name = $NameEdit.text.strip_edges()
	var phone = $PhoneEdit.text.strip_edges()
	var email = $EmailEdit.text.strip_edges()
	var college = $CollegeEdit.text.strip_edges()
	var stream = $StreamEdit.text.strip_edges()
	var year = $YearEdit.selected
	var error_label = $ErrorMsg  # Reference to the error message label

	# Reset error label
	error_label.visible = false
	error_label.text = ""

	# Validation checks
	if name.is_empty():
		set_error("Name cannot be empty.")
		return
	
	if phone.is_empty() or not is_valid_phone(phone):
		set_error("Enter a valid phone number.")
		return

	if email.is_empty():
		set_error("Email Cannot be empty.")
		return
		
	if !is_valid_email(email):
		set_error("Invalid email format. Please enter a valid email.")
		return
	
	if college.is_empty():
		set_error("College name cannot be empty.")
		return

	if stream.is_empty():
		set_error("Please enter your field of study.")
		return

	if year < 0:
		set_error("Please select a valid academic year.")
		return

	# If all validations pass, proceed with login
	error_label.visible = false  # Hide error message
	#var task = await Firebase.Auth.login_anonymous()
	#anonymous_login()
	anonymous_login()

#
#func check_existing_user(email: String, phone: String) -> bool:
	#print("Checking")
	#var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
#
	## Create a FirestoreQuery instance
	#var query := FirestoreQuery.new()
	## Add conditions to check for existing email
	#query.from("users").where("user_email", FirestoreQuery.OPERATOR.EQUAL, email)
	##var task: FirestoreTask = await collection.qury(query)
	#
	## Execute the query
	#var results = await Firebase.Firestore.query(query)
#
	## Check if any documents were returned
	#if results.size() > 0:
		#print("Email already in use.")
		#return false
	#else:
	## Email does not exist
		#print("Email is available.")
#
	## ✅ Check for existing phone number separately
	#var phone_query := FirestoreQuery.new()
	#phone_query.add_where("user_phone", FirestoreQuery.OPERATOR.EQUAL, phone)
	#var phone_results = await Firebase.Firestore.query(query)
#
	## Check if any documents were returned
	#if phone_results.size() > 0:
		#print("Phone already in use.")
		#return false
	#else:
	## Email does not exist
		#print("Phone is available.")
	## ✅ If no duplicates, proceed with login
	##anonymous_login()
	#
	#return true

# Function to display error messages
func set_error(message: String):
	var error_label = $ErrorMsg
	error_label.text = message
	error_label.visible = true

# Helper function to validate phone number (basic check for digits)
func is_valid_phone(phone: String) -> bool:
	return phone.is_valid_int() and phone.length() >= 10
	
func anonymous_login():
	print("Logging In Please wait")
	$Label2.text = 'Signing up. Please Wait..'
	var email = $EmailEdit.text
	var password = "Player@2s025#2"  # Ensure this meets Firebase's password requirements
	
	var task = await Firebase.Auth.signup_with_email_and_password(email, password)
	if task != null:
		$ErrorMsg.hide()
		print("Signup successful! UID: ", task.user["localid"])
		$Label2.text = "Signup Successful!"
	else:
		set_error("Error in Account Creating")
	

func _on_signup_succeeded(user_info):
	print("signup successful! UID: ", user_info['localid'])
	$Label2.text = 'Signup Success. Logging in..'
	print(user_info)
	var user_data = UserData.load_or_create()
	user_data.user_id = user_info["localid"] 
	user_data.name = $NameEdit.text
	user_data.score = 0
	user_data.save()
	$Label2.text = 'User Saving..'
	print("User ID saved: ", user_data.user_id)
	var task =  Firebase.Auth.login_anonymous()
	set_error("")
	$Label2.text = 'Setting Games...'
	Firebase.Auth.save_auth(user_info)
	save_data()
	#user_info['email'],'Player@2025#2'/
func _on_login_failed(error):
	print("login failed",error)#

func _on_signup_failed(error):
	print("signup failed: ", error)
	
func _on_login_succeeded(auth):
	$Label2.text = 'Loading...'
	print("Login successful!")
	
		


func save_data():
	var auth = Firebase.Auth.auth
	var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
	var name = $NameEdit.text.strip_edges()
	var phone = $PhoneEdit.text.strip_edges()
	var email = $EmailEdit.text.strip_edges()
	var college = $CollegeEdit.text.strip_edges()
	var stream = $StreamEdit.text.strip_edges()
	var year = $YearEdit.selected
	
	var data: Dictionary = {
		"user_name": name,
		"user_email": email,
		"user_phone": phone,
		"college":college,
		"stream":stream,
		"year":year,
		"level": 1,
		"trophies": points,  # Fixed typo
	}
	var document: FirestoreDocument = await collection.add(auth.localid,data)
	if document:
		get_tree().change_scene_to_file("res://Games.tscn")
	else:
		set_error("Error in Saving Try Again!")
		#get_tree().change_scene_to_file("res://games/World.tscn")
	#var task: FirestoreTask = collection.update(document)
	# Optional: Handle success or failure
	#task.connect("completed", Callable(self, "_on_data_saved"))
	#task.connect("failed", Callable(self, "_on_data_save_failed"))
	
func _on_data_saved():
	print("Data saved successfully!")

func _on_data_save_failed(error):
	print("Failed to save data: ", error)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func is_valid_email(email: String) -> bool:
	var email_regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
	var regex = RegEx.new()
	regex.compile(email_regex)
	return regex.search(email) != null
