extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var fade_time := 1.0
var current_stream: AudioStream = null

func _ready():
	add_child(music_player)
	music_player.volume_db = 0

func play_music(stream: AudioStream, fade: float = 0.8):
	if stream == current_stream:
		return

	current_stream = stream
	fade_time = fade
	_crossfade_to(stream)

func _crossfade_to(new_stream: AudioStream):
	var tween = create_tween()

	tween.tween_property(music_player, "volume_db", -40.0, fade_time)

	tween.tween_callback(func():
		music_player.stream = new_stream
		music_player.play()
	)

	tween.tween_property(music_player, "volume_db", 0.0, fade_time)
