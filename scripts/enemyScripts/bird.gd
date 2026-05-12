extends "res://scripts/enemyScripts/enemy.gd"
@onready var anim = $BirdFlap


enum State {
	CHASE,
	CHARGING,
	DASHING
}

var taking_hit = false

var chase_speed = 100.0

var state = State.CHASE

#Dash
var dash_speed = 1200.0
var charge_time = 0.7
var min_dash_cooldown = 2
var max_dash_cooldown = 5
var dash_direction = Vector2.ZERO
var dash_target = Vector2.ZERO
var dash_distance = 500.0
var charge_timer = 0.0
var cooldown_timer = 0.0

@onready var charge_sound = $Charge
@onready var dash_sound = $Dash
@onready var hurtbox = $Area2D

func _ready():
	collision_layer = 0
	collision_mask = 0
	hurtbox.collision_mask = 0
	hurtbox.collision_layer = 0
	
	enemySpeed = 0
	chase_speed = 0
	cooldown_timer = 1000000
	anim.play("load")
	await anim.animation_finished
	hurtbox.set_collision_layer_value(4, true)
	hurtbox.set_collision_mask_value(2, true)
	set_collision_layer_value(4, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(1, true)
	hurtbox.set_collision_mask_value(4, true)
	set_collision_mask_value(4, true)
	chase_speed = 100.0
	enemySpeed = 150.0
	
	super()
	enemyHealth = 5
	anim.play("flap")
	cooldown_timer = randf_range(min_dash_cooldown, max_dash_cooldown)


func _physics_process(delta):
	match state: # basically switch: case
		State.CHASE:
			chase_player(delta)
			
			cooldown_timer -= delta
			
			if cooldown_timer <= 0:
				start_charge()
		
		State.CHARGING:
			velocity = velocity.lerp(Vector2.ZERO, 0.15)
			move_and_slide()
			
			charge_timer -= delta
			
			if charge_timer <= 0:
				start_dash()
		
		State.DASHING:
			var direction_to_target = global_position.direction_to(dash_target)
			velocity = direction_to_target * dash_speed
			
			move_and_slide()
			
			if get_slide_collision_count() or global_position.distance_to(dash_target) < 20: 
				end_dash()

func chase_player(_delta):
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * chase_speed
	move_and_slide()
	
	# flip sprite
	if direction.x > 0:
		anim.flip_h = true
	else:
		anim.flip_h = false

func start_charge():
	state = State.CHARGING
	charge_timer = charge_time
	
	# Save player's CURRENT position
	dash_direction = global_position.direction_to(player.global_position)
	dash_target = global_position + dash_direction * dash_distance
	
	charge_sound.pitch_scale = randf_range(0.95, 1.05)
	charge_sound.play()
	
	anim.play("charge")

func start_dash():
	state = State.DASHING
	
	# Disable enemy collision
	set_collision_mask_value(4, false)
	
	dash_sound.pitch_scale = randf_range(0.9, 1.1)
	dash_sound.play()
	
	anim.play("dive")

func end_dash():
	state = State.CHASE
	
	# Enable enemy collision
	set_collision_mask_value(4, true)
	
	cooldown_timer = randf_range(min_dash_cooldown, max_dash_cooldown)
	anim.play("flap")

func take_damage(damage: float):
	super(damage)
	
	if taking_hit:
		return
	
	taking_hit = true
	
	anim.play("hit")


func _on_bird_flap_animation_finished():
	if anim.animation == "hit":
		taking_hit = false
		
		match state:
			State.CHASE:
				anim.play("flap")
			State.CHARGING:
				anim.play("charge")
			State.DASHING:
				anim.play("dive")
