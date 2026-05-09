extends "res://scripts/enemyScripts/enemy.gd"
@onready var anim = $BirdFlap

enum State {
	CHASE,
	CHARGING,
	DASHING
}

var chase_speed = 100.0

var state = State.CHASE

#Dash
var dash_speed := 1200.0
var charge_time := 0.7
var dash_time := 0.25
var dash_cooldown := 2.5
var dash_direction := Vector2.ZERO

var charge_timer := 0.0
var dash_timer := 0.0
var cooldown_timer := 0.0

func _ready():
	enemyHealth = 5
	anim.play("default")
	super()

func _physics_process(delta):
	match state: # basically switch: case
		State.CHASE:
			chase_player(delta)
			
			cooldown_timer -= delta
			
			if cooldown_timer <= 0:
				start_charge()
		
		State.CHARGING:
			velocity = Vector2.ZERO
			move_and_slide()
			
			charge_timer -= delta
			
			if charge_timer <= 0:
				start_dash()
		
		State.DASHING:
			velocity = dash_direction * dash_speed
			move_and_slide()
			
			dash_timer -= delta
			
			if dash_timer <= 0:
				end_dash()
	"""
	var direction = global_position.direction_to(player.global_position)
	if direction.x > 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
	velocity = direction * enemySpeed
	move_and_slide()
	"""
	if (enemyHealth <= 0):
		queue_free()

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
	
	anim.play("charge")

func start_dash():
	state = State.DASHING
	dash_timer = dash_time
	
	anim.play("dive")

func end_dash():
	state = State.CHASE
	cooldown_timer = dash_cooldown

	anim.play("flap")

func take_damage(damage: float):
	enemyHealth -= damage
	anim.play("hit")

func _on_bird_flap_animation_looped() -> void:
	anim.play("default")
