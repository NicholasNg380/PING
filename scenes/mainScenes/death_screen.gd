extends Control
signal restart

func _ready() -> void:
	self.visible = false
	pass

func be_visible():
	self.visible = true

func set_label(score):
	$Label.text = "You Died!\n\nYour Score was: %s" % [(str(score))]

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainScenes/main_menu.tscn")

func _on_retry_button_button_up() -> void:
	print("d")
	restart.emit()
