extends Node

signal tool_equiped
signal tool_unequiped
signal new_day(day)
signal sunset
signal sunrise
signal store_changed(prop)

var gameStore: Resource = preload("res://resources/stores/GameStore.tres")

const TIME_SCALE = 0.01
var is_day_counted = false
var is_day = true
var is_day_signaled = false
var is_night_signaled = false
var is_time_paused = false
var tiles_ground_ids = ["soil", "grassLight", "grassLightHeigh", "plantDead"]

var Paticles = null
var GroundLayer = null
var PlantLayer = null
var UI = null
var Shack = null
var Audio = null
var Item = preload("res://scenes/Item.tscn")

func _ready():
	gameStore.connect("store_changed", self, "_on_store_changed")

func calc_time(delta):
	gameStore.time += delta * (TIME_SCALE * gameStore.time_multiplier)
	
	# Calculate time
	gameStore.current_time = pow( abs(sin(gameStore.time) * 1), 1.7 )

	# Check if its a new day
	if(gameStore.current_time < 0.1):
		if(is_day_counted):
			return
		gameStore.set_prop("day_count", gameStore.day_count + 1)
		emit_signal("new_day", gameStore.day_count)
		is_day_counted = true
		print("its day: ", gameStore.day_count)
	else:
		is_day_counted = false
		
	# Check if its night or day
	is_day = true if gameStore.current_time > 0.5 else false
	
	if(is_day):
		if(!is_day_signaled):
			print("sunrise")
			emit_signal("sunrise")
			is_day_signaled = true
			is_night_signaled = false
	else:
		if(!is_night_signaled):
			print("sunset")
			emit_signal("sunset")
			is_night_signaled = true
			is_day_signaled = false

func _process(delta):
	if(!is_time_paused):
		calc_time(delta)

func pause_game():
	UI.show_pause_menu()
	is_time_paused = true
	
func resume_game():
	UI.hide_pause_menu()
	is_time_paused = false

func equip_tool(tool_to_equip):
	gameStore.current_tool = tool_to_equip
	emit_signal("tool_equiped")
	print('eqiped new tool: ', gameStore.current_tool)
	
func unequip_toll():
	gameStore.current_tool = null
	emit_signal("tool_unequiped")

func change_ground(cell_position, new_type):
	GroundLayer.set_cellv(cell_position, tiles_ground_ids.find(new_type))		

func change_plant_layer(cell_position, plant_name):
	var is_plant_on_position = PlantLayer.is_plant_on_position(cell_position)
	
	if(plant_name == ''):
		if(is_plant_on_position):
			PlantLayer.remove_plant(cell_position)
		
		return
	
	# Add plant if there is non yet
	if(!is_plant_on_position):
		GameWorld.Audio.play_sfx_random_pitch('Planting')
		var new_plant = PlantLayer.instsance_plant(cell_position, plant_name)
		return new_plant

func add_money(money_to_add):
	gameStore.money += money_to_add

func remove_money(money_to_remove):
	gameStore.money -= money_to_remove

func get_money():
	return gameStore.money

func get_current_tool():
	return gameStore.current_tool

func update_time_multiplier(value):
	gameStore.time_multiplier = value
	
func _on_store_changed(prop):
	emit_signal("store_changed", prop)
