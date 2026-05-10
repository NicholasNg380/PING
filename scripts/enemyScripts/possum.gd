extends "res://scripts/enemyScripts/enemy.gd"
@onready var anim = $PossumWalk

func _ready():
	enemySpeed = 0
	anim.play("load")
	await anim.animation_finished

	super()
	enemySpeed = 250.0
	anim.play("default")

func _physics_process(_delta):
	print(collision_layer)
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * enemySpeed * speed_multiplier
	move_and_slide()
	
	anim.flip_h = direction.x > 0

func take_damage(damage: float):
	super(damage)
	anim.play("hit")

func _on_possum_walk_animation_looped() -> void:
	anim.play("default")
	
