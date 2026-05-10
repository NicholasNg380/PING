extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var explo_animation = $Explosion
const ENEMY_HIT_SCORE = 5

var DAMAGE = 1.0
var SCALE_X: float
var SCALE_Y: float


signal update_score(score: int)

func _ready() -> void:
	explo_animation.play("default")
	DAMAGE = player.explosive_dmg
	SCALE_X = player.explo_scale_x
	SCALE_Y = player.explo_scale_y

func _on_explo_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		update_score.emit(ENEMY_HIT_SCORE)
		body.take_damage(DAMAGE)
