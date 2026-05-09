extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")

var enemySpeed = 150.0
var enemyHealth = 2

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemySpeed
	move_and_slide()
	if (enemyHealth <= 0):
		queue_free()

func take_damage():
	enemyHealth -= 1
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not body.invulnerable:
		body.take_player_damage()
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, 1200, 0.12)
