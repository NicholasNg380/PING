extends Node

enum Step {
	MOVE,
	ATTACK,
	PARRY,
	DASH,
	FINISH
}

var current_step = Step.MOVE

var parry_done = false
var dash_done = false

var parry_enemy_alive = false
var parry_attempted = false
var parry_enemy_exists = false

var enemy_scenes = {
	"dummy": preload("res://scenes/objects/Dummy.tscn"),
	"possum": preload("res://scenes/objects/Possum.tscn"),
	"bird": preload("res://scenes/objects/Bird.tscn")}
	
	

@onready var player = $"../Player"
@onready var ui = $"../TutorialUI"
@onready var stage = $"../Stage"
@onready var upgrade_ui = $"../UpgradeUI"
@onready var paddle = $"../Player/Paddle"

func _ready():
	upgrade_ui.hide()
	
	paddle.parried.connect(_on_player_parried)
	player.dashed.connect(_on_player_dashed)
	
	start_step(Step.MOVE)
	
func start_step(step):
	
	current_step = step
	
	match step: #match is case
		Step.MOVE:
			ui.show_text("Move with WASD")
			enable_player(true)
		
		Step.ATTACK:
			ui.show_text("Click to attack")
			spawn_dummy_enemy()
		
		Step.PARRY:
			ui.show_text("Parry the ball back")
			spawn_dummy_enemy()
			
			parry_enemy_alive = true
			parry_attempted = false
		
		Step.DASH:
			ui.show_text("Press Shift to dash")
		
		Step.FINISH:
			ui.show_text("Tutorial complete!")
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_file("res://scenes/mainScenes/main_menu.tscn")

func next_step():
	start_step(current_step + 1)

func _process(_delta):
	if current_step == Step.MOVE:
		if player.velocity.length() > 10:
			next_step()
			
func _on_enemy_killed():
	if current_step == Step.ATTACK:
		next_step()

	elif current_step == Step.PARRY:
		if not parry_attempted:
			_respawn_parry_enemy()

func _respawn_parry_enemy():
	if parry_enemy_exists:
		return

	await get_tree().create_timer(1.0).timeout

	if current_step == Step.PARRY:
		ui.show_text("Try parrying, not just attacking!")
		spawn_dummy_enemy()

func _on_player_parried():
	if current_step == Step.PARRY:
		parry_attempted = true
		next_step()

func _on_player_dashed():
	if current_step == Step.DASH:
		next_step()

func spawn_enemy(enemy_scene):
	if parry_enemy_exists and current_step == Step.PARRY:
		return
	
	var new_enemy = enemy_scene.instantiate()
	new_enemy.global_position = Vector2(1000, 0)

	if current_step == Step.PARRY:
		parry_enemy_exists = true
		new_enemy.died.connect(_on_parry_enemy_killed)
	else:
		new_enemy.died.connect(_on_enemy_killed)

	add_child(new_enemy)

func _on_parry_enemy_killed():
	parry_enemy_exists = false

	if current_step == Step.PARRY:
		if not parry_attempted:
			_respawn_parry_enemy()

func spawn_dummy_enemy():
	spawn_enemy(enemy_scenes["dummy"])

func enable_player(enabled: bool):
	player.set_process(enabled)
	player.set_physics_process(enabled)
