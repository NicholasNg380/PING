extends Node2D

var button_type = null

func _ready() -> void:
	pass

func _process(_delta):
	if button_type == "start":
		get_tree().change_scene_to_file("res://scenes/mainScenes/Game.tscn")
	
	elif button_type == "quit":
		print("quit game")

func _on_start_pressed() -> void:
	button_type = "start"

func _on_options_pressed() -> void:
	button_type = "options"

func _on_quit_pressed() -> void:
	button_type = "quit"

func _on_tutorial_pressed() -> void:
	button_type = "tutorial"
