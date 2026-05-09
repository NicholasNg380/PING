extends Node2D

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta):
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainScenes/Game.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	pass # Replace with function body.

func _on_tutorial_pressed() -> void:
	pass # Replace with function body.
