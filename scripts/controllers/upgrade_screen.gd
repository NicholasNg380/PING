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
@onready var bg = $Panel
var turned_off: bool = true

func _ready() -> void:
	self.visible = false

func _turn_on() -> void:
	upgrades.shuffle()
	chosen = upgrades.slice(0, 3)
	button1.icon = load(chosen[0]["asset_loc"])
	button1.get_child(0).text = chosen[0]["description"]
	inverse_visibilities()

func inverse_visibilities():
	self.visible = not self.visible
	
func turn_off():
	inverse_visibilities()

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
	upgrade_selected.emit()
	$Upgrade1.hide()
