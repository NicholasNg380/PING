extends Camera2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 5

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

@onready var ball = get_tree().get_first_node_in_group("Ball")

func _ready():
	if ball:
		ball.exploding.connect(_on_exploding)

func apply_shake():
	shake_strength = randomStrength

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		
		offset = random_offset()

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))


func _on_player_took_damage() -> void:
	apply_shake()

func _on_exploding():
	apply_shake()
