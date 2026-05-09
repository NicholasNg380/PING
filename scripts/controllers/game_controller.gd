extends Node2D

var remaining_possums = 0
var remaining_birds = 0

var spawn_timer = 0.0
var spawn_interval = 1.5

var levels = {
	1: {"possum": 3, "bird": 0},
	2: {"possum": 7, "bird": 0},
	3: {"possum": 12, "bird": 0},
	4: {"possum": 3, "bird": 1},
	5: {"possum": 5, "bird": 2},
	6: {"possum": 10, "bird": 2},
	7: {"possum": 15, "bird": 3},
	8: {"possum": 20, "bird": 4},
	9: {"possum": 30, "bird": 5},
	10: {"possum": 99, "bird": 10}
}

var enemy_scenes = {"possum": preload("res://scenes/objects/Possum.tscn"),
	"bird": preload("res://scenes/objects/Bird.tscn")}


func spawn_enemy(enemy_scene):
	var new_enemy = enemy_scene.instantiate()
	
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	
	add_child(new_enemy)

func spawn_possum():
	spawn_enemy(enemy_scenes["possum"])
	
func spawn_bird():
	spawn_enemy(enemy_scenes["bird"])

func spawn_wave(possum_num, bird_num):
	remaining_possums = possum_num
	remaining_birds = bird_num
	spawn_timer = 0.0

func spawn_one_enemy():
	var pool = []

	if remaining_possums > 0:
		pool.append("possum")
	if remaining_birds > 0:
		pool.append("bird")

	var choice = pool.pick_random()

	if choice == "possum":
		spawn_enemy(enemy_scenes["possum"])
		remaining_possums -= 1
	else:
		spawn_enemy(enemy_scenes["bird"])
		remaining_birds -= 1

#not functional yet
func load_level(path):
	for child in $CurrentLevel.get_children():
		child.queue_free()
		
	var level = load(path).instantiate()
	$CurrentLevel.add_child(level)

func start_level(level_id):
	var data = levels[level_id]
	spawn_wave(data["possum"], data["bird"])

func _ready():
	pass

func _process(delta):
	if remaining_possums <= 0 and remaining_birds <= 0:
		return 

	spawn_timer -= delta

	if spawn_timer <= 0:
		spawn_timer = spawn_interval
		spawn_one_enemy()
	
	if Input.is_action_just_pressed("spawnEnemy"):
		spawn_wave(1,1)

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				start_level(1)
			KEY_2:
				start_level(2)
			KEY_3:
				start_level(3)
			KEY_4:
				start_level(4)
			KEY_5:
				start_level(5)
			KEY_6:
				start_level(6)
			KEY_7:
				start_level(7)
			KEY_8:
				start_level(8)
			KEY_9:
				start_level(9)
			KEY_0:
				start_level(10)
