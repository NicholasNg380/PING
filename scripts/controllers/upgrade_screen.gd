extends Control

signal upgrade_selected(upgrade)
var player = preload("res://scripts/playerScripts/player.gd")

var upgrades = [{"name": "Speed", "asset_loc": "res://assets/sprites/icon.svg", "description": "Move faster"},
				{"name": "Strength", "asset_loc": "res://assets/sprites/icon.svg", "description": "Do more damage"},
				{"name": "UMMM", "asset_loc": "res://assets/sprites/icon.svg", "description": "Who knows???"},
				{"name": "UMMM", "asset_loc": "res://assets/sprites/icon.svg", "description": "Who knows???"},
				{"name": "UMMM", "asset_loc": "res://assets/sprites/icon.svg", "description": "Who knows???"},
				{"name": "UMMM", "asset_loc": "res://assets/sprites/icon.svg", "description": "Who knows???"},
				{"name": "UMMM", "asset_loc": "res://assets/sprites/icon.svg", "description": "Who knows???"},
				{"name": "UMMM", "asset_loc": "res://assets/sprites/icon.svg", "description": "Who knows???"}]
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
	
	button1.icon = load(chosen[0]["asset_loc"])
	button1.get_child(0).text = chosen[0]["description"]
	
	button2.icon = load(chosen[1]["asset_loc"])
	button2.get_child(0).text = chosen[1]["description"]

	button3.icon = load(chosen[2]["asset_loc"])
	button3.get_child(0).text = chosen[2]["description"]
	
func turn_off():
	self.visible = false

	button1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button3.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_upgrade_1_button_up() -> void:
	upgrade_selected.emit(chosen[0])
	upgrades.erase(chosen[0])
	turn_off()


func _on_upgrade_2_button_up() -> void:
	upgrade_selected.emit(chosen[1])
	upgrades.erase(chosen[1])
	turn_off()


func _on_upgrade_3_button_up() -> void:
	upgrade_selected.emit(chosen[2])
	upgrades.erase(chosen[2])
	turn_off()

func _on_confirm_pressed() -> void:
	var random_upgrade = chosen.pick_random()
	upgrade_selected.emit(random_upgrade)
	turn_off()
