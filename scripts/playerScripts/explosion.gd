extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var explo_animation = $Explosion
@onready var explo_radius = $Explo_radius
const ENEMY_HIT_SCORE = 5

var DAMAGE = 1.0
var SCALE_X: float
var SCALE_Y: float


signal update_score(score: int)

func _ready() -> void:
	
	DAMAGE = player.explosive_dmg
	SCALE_X = player.explo_scale_x
	SCALE_Y = player.explo_scale_y
	print(SCALE_X)
	explo_radius.scale = Vector2(SCALE_X/10, SCALE_Y/10)
	explo_animation.scale = Vector2(SCALE_X/20, SCALE_Y/20)
	explo_animation.play("default")
	
	

func _on_explo_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		update_score.emit(ENEMY_HIT_SCORE)
		body.take_damage(DAMAGE)
