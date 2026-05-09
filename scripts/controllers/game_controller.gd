extends Node2D

var remaining_possums = 0
var remaining_birds = 0

var enemy_speed_multiplier: float = 1.0

var spawn_timer = 0.0
var spawn_interval = 1.5

var wave_finished = false

var current_level = 1

var current_score: int

enum GameState {
	PLAYING,
	UPGRADES
}

var state = GameState.PLAYING

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
	
	new_enemy.speed_multiplyer = enemy_speed_multiplier
	
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
	if remaining_possums > 0 and remaining_birds > 0:
		if randf() < 0.7:
			spawn_enemy(enemy_scenes["possum"])
			remaining_possums -= 1
		else:
			spawn_enemy(enemy_scenes["bird"])
			remaining_birds -= 1

	elif remaining_possums > 0:
		spawn_enemy(enemy_scenes["possum"])
		remaining_possums -= 1

	elif remaining_birds > 0:
		spawn_enemy(enemy_scenes["bird"])
		remaining_birds -= 1

func start_level(level_id):
	current_level = level_id
	var data = levels[level_id]
	
	enemy_speed_multiplier = 1.0 + (level_id - 1) * 0.15
	
	spawn_interval = max(0.4, 1.5 - level_id * 0.1)
	spawn_wave(data["possum"], data["bird"])

func start_next_level():
	current_level += 1
	start_level(current_level)

func get_alive_enemies():
	return get_tree().get_nodes_in_group("enemies").size()

func is_wave_complete():
	return remaining_possums <= 0 and remaining_birds <= 0 and get_alive_enemies() == 0

func show_upgrades():
	state = GameState.UPGRADES

	# stop spawning completely
	spawn_timer = 0.0
	
	$UpgradeUI.turn_on()

func _on_upgrade_selected(upgrade):
	state = GameState.UPGRADES
	
	$UpgradeUI.turn_off()
	
	print("UPGRADE SELECTED:", upgrade)
	
	await get_tree().process_frame

	state = GameState.PLAYING
	wave_finished = false

	start_next_level()

func _ready():
	$UpgradeUI.upgrade_selected.connect(_on_upgrade_selected)
	start_level(1)

func _process(delta):
	if state != GameState.PLAYING:
		return
	
	if state == GameState.PLAYING and is_wave_complete() and !wave_finished:
		wave_finished = true
		show_upgrades()

	spawn_timer -= delta

	if spawn_timer <= 0:
		spawn_timer = spawn_interval
		spawn_one_enemy()

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

func increase_score(score: int):
	current_score += score
