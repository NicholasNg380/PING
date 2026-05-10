class_name Player extends CharacterBody2D

@onready var upgrade = $"../UpgradeUI"
@onready var penguin_hit = $penguin_hit
@onready var penguin_death = $penguin_death

'''
Player Variables
'''
# Movement
var MAX_SPEED: float = 500.0
const ACCELERATION: int = 15
const FRICTION: int = 13

# Dashing
const DASH_SPEED: int = 4000
const DASH_TIME: float = 0.12
var can_dash: bool = true
var dash_timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO
var DASH_RELOAD_COST: float = 0.5
var dash_reload_timer: float = 0.0

# Animation
var facing_right: bool = true
var swinging: bool = false

var max_health: float = 3
var health: int = 3

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

const I_FRAME_TIME: float = 1.25
var i_frame_timer: float = 0.0
var invulnerable: bool = false 

'''
Ball Variables
'''
var ball_speed: float = 700.0
var ball_speed_multi: float = 1.0
var ball_return_speed: float = 850.0
var ball_return_wall_speed: float = 1000.0
var ball_return_speed_multi: float = 1.0
var ball_damage: float = 1.0
var ball_damage_multi: float = 0.0
var ball_return_damage_multi: float = 0.5
var ball_scale_x: float = 0.5
var ball_scale_y: float = 0.5

var explosion: bool = true
var explosive_dmg: float = 1
var explo_scale_x: float = 10.0
var explo_scale_y: float = 10.0

@onready var health_bar = $"../HealthBar"

signal update_stats
signal dashed
signal took_damage

signal game_over
signal update_score(score: int)
signal reset_combo
signal increase_combo

func _ready() -> void:
	health_bar.set_max_health(max_health)
	add_to_group("Player")
	upgrade.upgrade_selected.connect(_on_upgrade_selected)
	
func _process(delta: float) -> void:
	if get_global_mouse_position().x < global_position.x:
		facing_right = false
	else:
		facing_right = true

func _physics_process(delta):
	if i_frame_timer > 0.0:
		$AnimationPlayer.play("flash")
		i_frame_timer -= delta
		if i_frame_timer <= 0.0:
			i_frame_timer = 0.0
			invulnerable = false
			$AnimationPlayer.stop()
			modulate.a = 1.0
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


func refersh_health():
	health = max_health
	health_bar.update_health(health)

func take_player_damage():
	penguin_hit.play()
	health -= 1
	took_damage.emit()
	health_bar.update_health(health)
	if (health <= 0):
		penguin_death.play()
		game_over.emit()
	
func _movement(delta: float) -> void:
	var input = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	var lerp_weight = delta * (ACCELERATION if input else FRICTION)
	
	if can_dash and Input.is_action_just_pressed("shift"):
		dashed.emit()
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
	
func _on_upgrade_selected(upgrade_entry: Dictionary):
	var name = upgrade_entry["name"]
	var stat = upgrade_entry["stat"]
	if name == "Speed":
		MAX_SPEED *= stat
	if name == "Damage":
		ball_damage_multi += stat
	if name == "Max Hp":
		max_health += stat
		health = max_health
		health_bar.change_max(max_health)
	if name == "Ball Speed":
		ball_speed_multi += stat
	if name == "Dash":
		DASH_RELOAD_COST -= stat
	if name == "Return Damage":
		ball_return_damage_multi += stat
	if name == "Return Speed":
		ball_return_speed_multi += stat
	if name == "Ball Size":
		ball_scale_x += stat
		ball_scale_y += stat
	if name == "Explosion":
		explosion = true
		explosive_dmg += stat
		explo_scale_x += (stat * 5)
		explo_scale_y += (stat * 5)
	update_stats.emit()

func _on_paddle_update_score(score: int) -> void:
	update_score.emit(score)
	increase_combo.emit()

func _on_ball_update_score(score: int) -> void:
	update_score.emit(score)
	


func _on_paddle_reset_combo() -> void:
	reset_combo.emit()
