class_name Ball extends Node2D


const SPEED: int = 1000
enum State {INACTIVE, HIT_ENEMY, HIT_PADDLE, HIT_WALL}
var ball_state = State.INACTIVE
var player
signal has_ball
var sprite
var direction

func _ready() -> void:
	player = get_parent()
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
	pass # Replace with function body.
