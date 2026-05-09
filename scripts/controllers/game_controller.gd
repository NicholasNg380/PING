extends Node2D

const ENEMY_NUM = 5

func spawn_enemy():
	var new_enemy = preload("res://scenes/objects/Enemy.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	add_child(new_enemy)

func _ready():
	for i in range(ENEMY_NUM):
		spawn_enemy()

func _process(_delta):
	if Input.is_action_just_pressed("spawnEnemy"):
		spawn_enemy()
