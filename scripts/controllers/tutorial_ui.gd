extends Control

@onready var label = $Label

var current_message := ""

func show_text(text: String):
	if text == current_message:
		return
	
	current_message = text
	label.text = text
