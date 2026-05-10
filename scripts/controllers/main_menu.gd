extends Node2D

var button_type = null
@onready var ping_animation = $PingAnimation
@onready var click_sound = $ClickSound
@onready var hover_sound = $HoverSound

func _ready() -> void:
	#MusicManager.play_music(menu_music, 0.8)
	get_tree().paused = false
	ping_animation.play("idle")
	pass

func _process(_delta):
	if button_type == "start":
		get_tree().change_scene_to_file("res://scenes/mainScenes/Game.tscn")
	
	elif button_type == "tutorial":
		get_tree().change_scene_to_file("res://scenes/mainScenes/tutorial.tscn")
	
	elif button_type == "quit":
		get_tree().quit()

func _on_start_pressed() -> void:
	click_sound.play()
	button_type = "start"

func _on_quit_pressed() -> void:
	click_sound.play()
	button_type = "quit"

func _on_tutorial_pressed() -> void:
	click_sound.play()
	button_type = "tutorial"


func _on_start_mouse_entered() -> void:
	hover_sound.play()


func _on_tutorial_mouse_entered() -> void:
	hover_sound.play()


func _on_quit_mouse_entered() -> void:
	hover_sound.play()
