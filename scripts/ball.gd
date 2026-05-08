class_name Ball extends Node2D

const SPEED: int = 100

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
