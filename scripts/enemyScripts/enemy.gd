extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")

var enemySpeed = 150.0
var enemyHealth = 2

const KNOCKBACK_POWER: int = 1200
const KNOCKBACK_TIME: float = 0.06

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemySpeed
	move_and_slide()
	if (enemyHealth <= 0):
		queue_free()

func _ready():
	add_to_group("enemies")

func take_damage():
	enemyHealth -= 1
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not player.invulnerable and body.is_in_group("Player"):
		body.take_player_damage()
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, KNOCKBACK_POWER, KNOCKBACK_TIME)
