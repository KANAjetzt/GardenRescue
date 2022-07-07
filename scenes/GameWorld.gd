extends Node

var tools_shack = []
var tools_store = []
var plants_shack = []
var plants_store = []
var current_tool = null
var current_plant = null
var tiles_ground = null
var tiles_ground_ids = ["grassDead", "grassLight", "grassLightHeigh", "plantDead"]

signal tool_equiped
signal plant_equiped

func equip_tool(tool_to_equip):
	current_tool = tool_to_equip.to_lower()
	emit_signal("tool_equiped")
	print('eqiped new tool: ', current_tool)
	
func equip_plant(plant_to_equip):
	current_plant = plant_to_equip.to_lower()
	emit_signal("plant_equiped")
	print('eqiped new plant: ', current_plant)

func change_ground(cell_position, new_type):
	tiles_ground.set_cellv(cell_position, tiles_ground_ids.find(new_type))
