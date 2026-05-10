extends Control

signal upgrade_selected(upgrade_entry: Dictionary)
signal added_upgrade()
signal refresh_health

var player = preload("res://scripts/playerScripts/player.gd")

var upgrades = [{"name": "Speed", "asset_loc": "res://assets/sprites/upgrades/speed_upgrade.png", "description": "Move faster", "stat": 1.5},
				{"name": "Damage", "asset_loc": "res://assets/sprites/upgrades/damage_upgrade.png", "description": "Do more damage", "stat": 1.0},
				{"name": "Max Hp", "asset_loc": "res://assets/sprites/upgrades/more_health_upgrade.png", "description": "Increase max hp", "stat": 1.0},
				{"name": "Ball Speed", "asset_loc": "res://assets/sprites/upgrades/move_speed_upgrade.png", "description": "Increase ball speed", "stat": 0.5},
				{"name": "Dash", "asset_loc": "res://assets/sprites/dash_cooldown_upgrade.png", "description": "Lower the dash cooldown", "stat": 0.15},
				{"name": "Return Damage", "asset_loc": "res://assets/sprites/upgrades/return_damage_upgrade.png", "description": "Do more on return damage", "stat": 0.5},
				{"name": "Return Speed", "asset_loc": "res://assets/sprites/upgrades/return_speed.png", "description": "Increase ball speed on return", "stat": 0.5},
				{"name": "Ball Size", "asset_loc": "res://assets/sprites/upgrades/bigger_ball_upgrade.png", "description": "Increase ball size", "stat": 0.1},
				{"name": "Explosion", "asset_loc": "res://assets/sprites/explosion_upgrade.png", "description": "Increase size and damage of explosion", "stat": 1.0}]
var used_upgrades = []
var rng = RandomNumberGenerator.new()
var chosen

@onready var button1 = $Upgrade1
@onready var button2 = $Upgrade2
@onready var button3 = $Upgrade3
@onready var bg = $Panel

func _ready() -> void:
	self.visible = false

func turn_on() -> void:
	self.visible = true
	
	button1.mouse_filter = Control.MOUSE_FILTER_STOP
	button2.mouse_filter = Control.MOUSE_FILTER_STOP
	button3.mouse_filter = Control.MOUSE_FILTER_STOP
	
	upgrades.shuffle()
	chosen = upgrades.slice(0, 3)
	
	button1.texture_normal = load(chosen[0]["asset_loc"])
	button1.get_child(0).text = chosen[0]["description"]
	
	button2.texture_normal = load(chosen[1]["asset_loc"])
	button2.get_child(0).text = chosen[1]["description"]

	button3.texture_normal = load(chosen[2]["asset_loc"])
	button3.get_child(0).text = chosen[2]["description"]
	
func turn_off():
	self.visible = false

	button1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button3.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_upgrade_1_button_up() -> void:
	upgrade_selected.emit(chosen[0])
	turn_off()


func _on_upgrade_2_button_up() -> void:
	print(chosen[1])
	upgrade_selected.emit(chosen[1])
	turn_off()


func _on_upgrade_3_button_up() -> void:
	upgrade_selected.emit(chosen[2])
	turn_off()

func _on_refresh_health_pressed() -> void:
	refresh_health.emit()
	turn_off()
