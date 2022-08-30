extends Node

signal tool_equiped
signal tool_unequiped
signal plant_equiped
signal new_day(day)
signal sunset
signal sunrise

const TIME_SCALE = 0.01
var time = 0
var current_time = 0
var time_multiplier = 3
var day_count = 0
var is_day_counted = false
var is_day = true
var is_day_signaled = false
var is_night_signaled = false

var money = 1500


var tools_shack = []
var tools_store = []
var plants_shack = []
var plants_store = []
var current_tool = null
var current_seed = null
var current_plant = null
var tiles_ground = null
var tiles_ground_ids = ["soil", "grassLight", "grassLightHeigh", "plantDead"]
var paticles = null

var GroundLayer = null
var PlantLayer = null
var UI = null
var Shack = null
var Audio = null
var Item = preload("res://scenes/Item.tscn")

func _process(delta):
	time += delta * (TIME_SCALE * time_multiplier)
	
	# Calculate time
	current_time = pow( abs(sin(time) * 1), 0.5 )

	# Check if its a new day
	if(current_time < 0.1):
		if(is_day_counted):
			return
		day_count += 1
		emit_signal("new_day", day_count)
		is_day_counted = true
		print("its day: ", day_count)
	else:
		is_day_counted = false
		
	# Check if its night or day
	is_day = true if current_time > 0.5 else false
	
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
	

func equip_tool(tool_to_equip):
	current_tool = tool_to_equip
	emit_signal("tool_equiped")
	print('eqiped new tool: ', current_tool)
	
func unequip_toll():
	current_tool = null
	emit_signal("tool_unequiped")
	
func equip_plant(plant_to_equip):
	current_plant = plant_to_equip.to_lower()
	emit_signal("plant_equiped")
	print('eqiped new plant: ', current_plant)

func change_ground(cell_position, new_type):
	GroundLayer.set_cellv(cell_position, tiles_ground_ids.find(new_type))		

func change_plant_layer(cell_position, plant_name):
	var is_plant_on_position = PlantLayer.is_plant_on_position(cell_position)
	
	if(plant_name == ''):
		if(is_plant_on_position):
			PlantLayer.remove_plant(cell_position)
		
		return
	
	# check if there is a plant allready
	if(!is_plant_on_position):
		# if not add plant
		GameWorld.Audio.play_sfx_random_pitch('Planting')
		var new_plant = PlantLayer.instsance_plant(cell_position, plant_name)
		return new_plant
