extends Node

var _save := SaveGameAsJSON.new()
onready var ui = $UI


func _ready():
	randomize()
	
	ui.connect("save_requested", self, "_save_game")

func _save_game() -> void:
	_save.write_savegame()
