extends CharacterBody2D

@export var speed = 400

func _physics_process(delta):
	var direction = Input.get_vector("left", "down", 
	"right", "up")
	velocity = direction * 600
	move_and_slide()
