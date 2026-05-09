extends HBoxContainer

var heart_img = preload("res://assets/sprites/ui/health/fish_health.png")
var dead_heart_img = preload("res://assets/sprites/ui/health/dead_fish_no_health.png")
var max_health
var current_health
var heart = preload("res://scenes/objects/health.tscn")

var healths = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func set_max_health(n):
	max_health = n
	current_health = max_health
	initiate_hearts()

func update_health(n):
	current_health = n
	redo_hearts()

func change_max(n):
	max_health = n
	current_health = max_health
	initiate_hearts()

func initiate_hearts():
	for child in get_children():
		child.queue_free()
	healths.clear()
	for i in range(max_health):
		var temp_instance = heart.instantiate()
		add_child(temp_instance)
		healths.append(temp_instance)

func redo_hearts():
	var num_dead = max_health-current_health
	for i in range(healths.size()):
		if i > (healths.size()-num_dead-1):
			healths[i].texture = dead_heart_img
		else:
			healths[i].texture = heart_img
	
