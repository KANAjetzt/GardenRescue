extends Node

var _save := SaveGameAsJSON.new()
onready var ui = $UI

func _ready():
	randomize()
	
	_save.connect("game_saved" ,self, "_handle_game_saved")
	
	ui.connect("reload_requested", self, "_create_or_load_save")
	ui.connect("save_requested", self, "_save_game")
	_create_or_load_save()

func _save_game() -> void:
	_save.write_savegame()
	
func _create_or_load_save() -> void:
	if _save.save_exists():
		_save.load_savegame()

func _handle_game_saved():
	ui.show_toast_message("Game Saved!")
