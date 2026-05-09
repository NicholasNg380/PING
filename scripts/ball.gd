class_name Ball extends Node2D


const SPEED: int = 1000
const WALLRETURNSPEED: int = 2500
enum State {INACTIVE, HIT_ENEMY, HIT_PADDLE, HIT_WALL}
var ball_state = State.INACTIVE
var player
signal has_ball
signal can_parry
signal cannot_parry

var sprite
var direction

func _ready() -> void:
	player = get_parent()
	global_position = player.global_position
	sprite = $BallSprite
	set_as_top_level(true)
	pass

func _process(delta: float) -> void:
	if ball_state == State.INACTIVE:
		sprite.visible = false
		global_position = player.global_position
	elif ball_state == State.HIT_PADDLE:
		sprite.visible = true
		global_position += direction * SPEED * delta
	elif ball_state == State.HIT_ENEMY:
		direction = global_position.direction_to(player.global_position)
		global_position += direction * SPEED * delta
	else:
		direction = global_position.direction_to(player.global_position)
		global_position += direction * WALLRETURNSPEED * delta

func hit_paddle():
	ball_state = State.HIT_PADDLE
	pass

func _on_ball_hit_box_body_entered(body: Node2D) -> void:
	if ball_state == State.HIT_PADDLE:
		if body.is_in_group("Enemy"):
			ball_state = State.HIT_ENEMY
			body.take_damage()
	if ball_state == State.HIT_ENEMY or ball_state == State.HIT_WALL:
		if body.is_in_group("Player"):
			ball_state = State.INACTIVE
			has_ball.emit()
			cannot_parry.emit()

func _on_ball_hit_box_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Parry_Area"):
		can_parry.emit()
	print(area.get_parent())
	print(area.get_parent().is_in_group("Wall"))
	if area.get_parent().is_in_group("Wall"):
		print("Hit Wall")
		ball_state = State.HIT_WALL
		
