extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("Player")

signal died

var speed_multiplier: float = 1.0
var hp_multiplier: float = 1.0
var enemySpeed: float = 150.0
var enemyHealth: float = 2.0
var max_health: float = 2.0

var can_damage_player: bool = true

const KNOCKBACK_POWER: int = 1200
const KNOCKBACK_TIME: float = 0.06

@onready var damage_sound = $TakeDamage

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
		
	velocity = direction * enemySpeed * speed_multiplier
	move_and_slide()

func _disable_enemy():
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)

func take_damage(damage: float):
	damage_sound.play()
	enemyHealth -= damage
	
	if (enemyHealth <= 0):
		died.emit()
		
		# hide enemy so it looks dead
		visible = false
		call_deferred("_disable_enemy")
		
		# wait for sound to finish
		await damage_sound.finished
		
		queue_free()

func apply_scaling():
	enemyHealth = max_health * hp_multiplier

func _ready():
	add_to_group("enemies")
	apply_scaling()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if can_damage_player and not player.invulnerable and body.is_in_group("Player"):
		body.take_player_damage()
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, KNOCKBACK_POWER, KNOCKBACK_TIME)
	#if player.explosion and body.is_in_group("Ball"):
		#var explode = explosion.instatiate()
		#explosions.poeision = 
		
