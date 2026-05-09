extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
func change_score(score):
	$Label2.text = "Score: %s" % [(str(score))]
