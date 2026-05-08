extends CharacterBody2D

# Movement
const MAX_SPEED: int = 800
const ACCELERATION: int = 15
const FRICTION: int = 13

# Dashing
const DASH_SPEED: int = 4000
const DASH_TIME: float = 0.12
var can_dash: bool = true
var dash_timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO
const DASH_RELOAD_COST: float = 0.5
var dash_reload_timer: float = 0.0


func _physics_process(delta):
	var input = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
	var lerp_weight = delta * (ACCELERATION if input else FRICTION)
	
	if can_dash and Input.is_action_just_pressed("shift"):
		can_dash = false
		dash_timer = DASH_TIME
		dash_reload_timer = DASH_RELOAD_COST
				
		velocity = input * DASH_SPEED
	else:
		velocity = lerp(velocity, input * (MAX_SPEED), lerp_weight)

	if dash_timer > 0.0:
		dash_timer = max(0.0, dash_timer - delta)
	else:
		if dash_reload_timer > 0.0:
			dash_reload_timer  -= delta
		else:
			can_dash = true
			
	move_and_slide()
