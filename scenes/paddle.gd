class_name paddle extends Node2D

const BALL = preload("res://scenes/Ball.tscn")

var ball = null

@onready var arrow: Marker2D = $Marker2D
var hasBall: bool = true

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	if Input.is_action_just_pressed("hit"):
		if hasBall:
			hasBall = false
			if ball == null:
				var ball_instance = BALL.instantiate()
				get_parent().add_child(ball_instance)
				ball = ball_instance
			ball.has_ball.connect(_on_has_ball)
			ball.global_position = arrow.global_position
			ball.rotation = rotation
			ball.direction = arrow.global_position.direction_to(get_global_mouse_position())
			ball.hit_paddle()
			
func _on_has_ball():
	hasBall = true
	pass
