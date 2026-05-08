extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")

var enemySpeed = 150.0
var enemyHealth = 2

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemySpeed
	move_and_slide()
	if (enemyHealth <= 0):
		queue_free()

func take_damage():
	enemyHealth -= 1
	
