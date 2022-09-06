class_name SaveGameAsJSON
extends Reference

const SAVE_GAME_PATH := "user://save.json"

var version := 1

var gameStore: Resource = preload("res://resources/stores/GameStore.tres")
var plantStore: Resource = preload("res://resources/stores/PlantStore.tres")
var inventory_shack: Resource = preload("res://resources/inventorys/shack.tres")
var inventory_store: Resource = preload("res://resources/inventorys/store.tres")

var map_name := ""
var global_position := Vector2.ZERO

var _file := File.new()

func save_exists() -> bool:
	return _file.file_exists(SAVE_GAME_PATH)


func write_savegame() -> void:
	var error := _file.open(SAVE_GAME_PATH, File.WRITE)
	if error != OK:
		printerr("Could not open the file %s. Aborting save operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return

	var data = {
		"game_store": {
			"time": gameStore.time,
			"current_time": gameStore.current_time,
			"time_multiplier": gameStore.time_multiplier,
			"day_count": gameStore.day_count,
			"money": gameStore.money,
			"current_tool": gameStore.current_tool.unique_id if gameStore.current_tool else null
		},
		"plant_store": {
			"plants": plantStore.generate_JSON_dict()
		},
		"inventory_shack": {
			"items": inventory_shack.items
		},
		"inventory_store": {
			"items": inventory_store.items
		}
	}
	
	var json_string := JSON.print(data)
	_file.store_string(json_string)
	_file.close()


func load_savegame() -> void:
	var error := _file.open(SAVE_GAME_PATH, File.READ)
	if error != OK:
		printerr("Could not open the file %s. Aborting load operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return

	var content := _file.get_as_text()
	_file.close()

	var data: Dictionary = JSON.parse(content).result
	
	gameStore.time = data.game_store.time
	gameStore.current_time = data.game_store.current_time
	gameStore.time_multiplier = data.game_store.time_multiplier
	gameStore.set_prop("day_count", data.game_store.day_count)
	gameStore.set_prop("money", data.game_store.money)
	if(data.game_store.current_tool):
		gameStore.set_prop("current_tool", ItemDatabase.get_item_data(data.game_store.current_tool))
	
	# Load plants
	plantStore.load_plants(data.plant_store.plants)
	
	inventory_shack.items = data.inventory_shack.items
	print("load_savegame: ", inventory_shack.items)
	inventory_shack.emit_signal("loaded", inventory_shack.items)
	inventory_store.items = data.inventory_store.items
	inventory_store.emit_signal("loaded",inventory_store.items)
