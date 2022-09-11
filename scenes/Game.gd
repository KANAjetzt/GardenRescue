extends Node

var _save := SaveGameAsJSON.new()
onready var ui = $UI

func _ready():
	randomize()
	ui.connect("reload_requested", self, "_create_or_load_save")
	ui.connect("save_requested", self, "_save_game")
	_create_or_load_save()

func _save_game() -> void:
	_save.write_savegame()
	
func _create_or_load_save() -> void:
	if _save.save_exists():
		_save.load_savegame()
#	else:
#		_save.inventory.add_item("healing_gem", 3)
#		_save.inventory.add_item("sword", 1)

#		_save.map_name = "map_1"
#		_save.global_position = _player.global_position

#		_save.write_savegame()

	# After creating or loading a save resource, we need to dispatch its data
	# to the various nodes that need it.
#	_player.global_position = _save.global_position
#	_ui_inventory.inventory = _save.inventory
#	_player.stats = _save.character
#	_ui_info_display.character = _save.character
