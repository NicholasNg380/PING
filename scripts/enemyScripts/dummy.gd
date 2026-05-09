extends "res://scripts/enemyScripts/possum.gd"

func _ready():
	super()
	enemySpeed = 100.0
	enemyHealth = 1
	can_damage_player = false
