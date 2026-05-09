extends "res://scripts/enemyScripts/enemy.gd"
@onready var anim = $PossumWalk

func _ready():
	super()
	enemySpeed = 250.0
	enemyHealth = 2
	anim.play("default")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * enemySpeed * speed_multiplier
	move_and_slide()
	
	if direction.x > 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
		
	if (enemyHealth <= 0):
		queue_free()

func take_damage(damage: float):
	enemyHealth -= damage
	anim.play("hit")

func _on_possum_walk_animation_looped() -> void:
	anim.play("default")
	
