extends Node2D

var possumNum = 5
var birdNum = 0
var enemy_scenes = {"possum": preload("res://scenes/objects/Possum.tscn"),
	"bird": preload("res://scenes/objects/Bird.tscn")}


func spawn_enemy(enemy_scene):
	print(enemy_scene.resource_path)
	
	var new_enemy = enemy_scene.instantiate()
	
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	
	add_child(new_enemy)

func spawn_possum():
	print("possum spawned")
	spawn_enemy(enemy_scenes["possum"])
	
func spawn_bird():
	spawn_enemy(enemy_scenes["bird"])

func load_level(path):
	for child in $CurrentLevel.get_children():
		child.queue_free()
		
	var level = load(path).instantiate()
	$CurrentLevel.add_child(level)

func _ready():
	for i in range(possumNum):
		spawn_possum()

func _process(_delta):
	if Input.is_action_just_pressed("spawnEnemy"):
		spawn_possum()
