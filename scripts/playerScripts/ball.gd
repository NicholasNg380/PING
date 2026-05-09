class_name Ball extends Node2D

@onready var player = get_node("/root/Game/Player")

enum State {INACTIVE, HIT_ENEMY, HIT_PADDLE, HIT_WALL}
var ball_state = State.INACTIVE
signal has_ball
signal can_parry
signal cannot_parry
signal update_score(score: int)

const ENEMY_HIT_SCORE = 5

var sprite
var direction

var serve_cooldown := 0.0
const SERVE_DELAY := 0.25

'''
Player Hold Variables
'''
var SPEED: int 
var SPEED_MULTIPLIER: int
var RETURN_SPEED: int
var WALL_RETURN_SPEED: int
var RETURN_SPEED_MULTIPLIER: float
var DAMAGE: float
var DAMAGE_MULTIPLIER: float
var RETURN_DAMAGE_MULTIPLIER: float

@onready var catch_cooldown_bar = $"../TextureProgressBar"
var is_inactive = true

func _ready() -> void:
	player.update_stats.connect(_on_update_stats)
    	catch_cooldown_bar.visible = false
	SPEED = player.ball_speed
	SPEED_MULTIPLIER = player.ball_speed_multi
	RETURN_SPEED = player.ball_return_speed
	WALL_RETURN_SPEED = player.ball_return_wall_speed
	RETURN_SPEED_MULTIPLIER = player.ball_return_speed_multi
	DAMAGE = player.ball_damage
	DAMAGE_MULTIPLIER = player.ball_damage_multi
	RETURN_DAMAGE_MULTIPLIER = player.ball_return_damage_multi
	global_position = player.global_position
	sprite = $BallSpin
	set_as_top_level(true)
	pass
	
func _on_update_stats():
	SPEED = player.ball_speed
	SPEED_MULTIPLIER = player.ball_speed_multi
	RETURN_SPEED = player.ball_return_speed
	WALL_RETURN_SPEED = player.ball_return_wall_speed
	RETURN_SPEED_MULTIPLIER = player.ball_return_speed_multi
	DAMAGE = player.ball_damage
	DAMAGE_MULTIPLIER = player.ball_damage_multi
	RETURN_DAMAGE_MULTIPLIER = player.ball_return_damage_multi
	
func _process(delta: float) -> void:
	if serve_cooldown > 0.0:
		catch_cooldown_bar.visible = true
		serve_cooldown -= delta
		catch_cooldown_bar.value = 100*(1-(serve_cooldown/SERVE_DELAY))
	else:
		catch_cooldown_bar.visible = false
	if player.global_position.distance_to(global_position) <= 40 and !is_inactive:
		ball_state = State.INACTIVE
		is_inactive = true
		has_ball.emit()
	
	if ball_state == State.INACTIVE:
		sprite.hide()
		global_position = player.global_position
	elif ball_state == State.HIT_PADDLE:
		sprite.show()
		is_inactive = false
		global_position += direction * SPEED * SPEED_MULTIPLIER * delta
	elif ball_state == State.HIT_ENEMY:
		direction = global_position.direction_to(player.global_position)
		global_position += direction * RETURN_SPEED * RETURN_SPEED_MULTIPLIER * delta
	else:
		direction = global_position.direction_to(player.global_position)
		global_position += direction * WALL_RETURN_SPEED * RETURN_SPEED_MULTIPLIER * delta

func hit_paddle():
	is_inactive = false
	ball_state = State.HIT_PADDLE
	pass

func _on_ball_hit_box_body_entered(body: Node2D) -> void:
	if ball_state == State.HIT_PADDLE:
		if body.is_in_group("Enemy"):
			ball_state = State.HIT_ENEMY
			update_score.emit(ENEMY_HIT_SCORE)
			body.take_damage(DAMAGE + DAMAGE_MULTIPLIER)
	elif ball_state == State.HIT_ENEMY or ball_state == State.HIT_WALL:
		if body.is_in_group("Enemy"):
			body.take_damage(DAMAGE * RETURN_DAMAGE_MULTIPLIER)
		if body.is_in_group("Player"):
			ball_state = State.INACTIVE
			has_ball.emit()
			cannot_parry.emit()
			serve_cooldown = SERVE_DELAY

func _on_ball_hit_box_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Parry_Area"):
		can_parry.emit()
	if area.get_parent().is_in_group("Wall"):
		ball_state = State.HIT_WALL

func was_hit_off_wall():
	return ball_state == State.HIT_WALL
