class_name paddle extends Node2D

@onready var arrow: Marker2D = $Marker2D
var hasBall: bool = true
var canParry: bool = false
@onready var ball = $"../Ball"
@onready var hit = $HitBall
@onready var whoosh = $Whoosh


signal parried

const PARRY_SCORE = 10

signal reset_combo

signal update_score(score: int)


func _ready() -> void:
	ball.global_position = get_parent().global_position
	ball.has_ball.connect(_on_has_ball)
	ball.can_parry.connect(_on_can_parry)
	ball.cannot_parry.connect(_on_cannot_parry)


func _process(_delta: float) -> void:
	_animations()
	
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	if Input.is_action_just_pressed("hit") and ball.serve_cooldown <= 0.0:
		if hasBall:
			hit.play()
			hasBall = false
			canParry = false
			ball.global_position = arrow.global_position
			ball.rotation = rotation
			ball.direction = arrow.global_position.direction_to(get_global_mouse_position())
			ball.hit_paddle()
		elif canParry:
			hit.play()
			print("parry")
			parried.emit()
			if (!ball.was_hit_off_wall()):
				update_score.emit(PARRY_SCORE)
			canParry = false
			ball.rotation = rotation
			ball.direction = arrow.global_position.direction_to(get_global_mouse_position())
			ball.hit_paddle()

func _on_has_ball():
	reset_combo.emit()
	hasBall = true

func _on_can_parry():
	canParry = true

func _on_cannot_parry():
	canParry = false
	
func _animations():
	if Input.is_action_just_pressed("hit"):
		$PaddleReticle.hide()
		$SwingAnimation.play("swing")

func _on_swing_animation_animation_finished() -> void:
	$PaddleReticle.show()
