extends Node

var music_player: AudioStreamPlayer
var paused = false  # Keep track of pause state

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = load("res://assets/bg.ogg")
	music_player.volume_db = 10  # Adjust volume if needed
	music_player.play()

func play_music(new_track_path):
	if music_player.stream.resource_path != new_track_path:
		music_player.stream = load(new_track_path)
		music_player.play()
	elif not music_player.playing:  # If it's paused or stopped, resume
		music_player.play()

func stop_music():
	music_player.stream_paused = true
	paused = true

func run_music():
	if !music_player.playing:
		music_player.stream_paused = false  # Resume the music
		paused = false

func toggle_pause():
	if music_player.playing:
		music_player.stream_paused = true  # Pause the music
		paused = true
	else:
		music_player.stream_paused = false  # Resume the music
		paused = false
