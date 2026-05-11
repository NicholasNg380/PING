extends "res://scripts/enemyScripts/enemy.gd"
@onready var anim = $PossumWalk
@onready var hurtbox = $Area2D

func _ready():
	collision_layer = 0
	collision_mask = 0
	hurtbox.collision_mask = 0
	hurtbox.collision_layer = 0
	
	enemySpeed = 0
	anim.play("load")
	await anim.animation_finished
	hurtbox.set_collision_layer_value(4, true)
	hurtbox.set_collision_mask_value(2, true)
	set_collision_layer_value(4, true)
	set_collision_mask_value(2, true)
	hurtbox.set_collision_mask_value(4, true)
	set_collision_mask_value(4, true)

	super()
	enemySpeed = 250.0
	anim.play("default")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * enemySpeed * speed_multiplier
	move_and_slide()
	
	anim.flip_h = direction.x > 0

func take_damage(damage: float):
	super(damage)
	anim.play("hit")

func _on_possum_walk_animation_looped() -> void:
	anim.play("default")
	
