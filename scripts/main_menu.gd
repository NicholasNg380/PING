extends Control


signal start_game
func _ready() -> void:
	pass # Replace with function body.

func _on_start_game_button_button_up() -> void:
	start_game.emit()
	print("works")
	pass # Replace with function body.
