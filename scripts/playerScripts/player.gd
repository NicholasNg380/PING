class_name Player extends CharacterBody2D

# Movement
const MAX_SPEED: int = 500
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

# Animation
var facing_right: bool = true
var swinging: bool = false

var health: int = 3

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

const I_FRAME_TIME: float = 0.75
var i_frame_timer: float = 0.0
var invulnerable: bool = false 

func _physics_process(delta):
	if i_frame_timer > 0.0:
		i_frame_timer -= delta
		if i_frame_timer <= 0.0:
			i_frame_timer = 0.0
			invulnerable = false
			set_collision_layer_value(2, true)
			set_collision_layer_value(6, false)
			set_collision_mask_value(4, true)
	
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		_movement(delta)
	move_and_slide()
	if health <= 0:
		pass

func take_player_damage():
	health -= 1
	
func _movement(delta: float) -> void:
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
	_animations()

#Animation
func _animations():
	if Input.is_action_just_pressed("hit") and !swinging:
		swinging = true
		if facing_right:
			$AnimatedSprite2D.play("SwingRight")
		else:
			$AnimatedSprite2D.play("SwingLeft")
	
	if swinging:
		return
	
	if velocity.x > MAX_SPEED/4:
		$AnimatedSprite2D.play("WalkRight")
		facing_right = true
	elif velocity.x < -MAX_SPEED/4:
		$AnimatedSprite2D.play("WalkLeft")
		facing_right = false
	else:
		if facing_right:
			$AnimatedSprite2D.play("IdleRight")
		else:
			$AnimatedSprite2D.play("IdleLeft")

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "SwingRight" or $AnimatedSprite2D.animation == "SwingLeft":
		swinging = false
		
func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	i_frame_timer = I_FRAME_TIME
	invulnerable = true
	set_collision_layer_value(2, false)			
	set_collision_layer_value(6, true)
	set_collision_mask_value(4, false)
