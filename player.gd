extends CharacterBody2D

func _physics_process(delta):
	const SPEED = 600.0
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED

	move_and_slide()
