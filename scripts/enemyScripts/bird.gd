extends "res://scripts/enemyScripts/enemy.gd"
@onready var anim = $BirdFlap

func _ready():
	enemySpeed = 100.0
	enemyHealth = 5
	anim.play("default")
	super()

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	if direction.x > 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
	velocity = direction * enemySpeed
	move_and_slide()
	if (enemyHealth <= 0):
		queue_free()

func take_damage(damage: float):
	enemyHealth -= damage
	anim.play("hit")

func _on_bird_flap_animation_looped() -> void:
	anim.play("default")
