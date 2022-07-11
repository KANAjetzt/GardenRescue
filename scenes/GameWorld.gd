extends Node

signal tool_equiped
signal plant_equiped
signal new_day(day)

const TIME_SCALE = 1.05
var time = 0
var current_time = 0
var day_count = 0
var is_day_counted = false

var money = 1000


var tools_shack = []
var tools_store = []
var plants_shack = []
var plants_store = []
var current_tool = null
var current_seed = null
var current_plant = null
var tiles_ground = null
var tiles_ground_ids = ["grassDead", "grassLight", "grassLightHeigh", "plantDead"]

var PlantLayer = null
var UI = null
var Shack = null
var Item = preload("res://scenes/Item.tscn")

func _process(delta):
	time += delta * TIME_SCALE
	
	current_time = pow( abs(sin(time) * 1), 0.5 )
	if(current_time < 0.1):
		if(is_day_counted):
			return
		day_count += 1
		emit_signal("new_day", day_count)
		is_day_counted = true
		print("its day: ", day_count)
	else:
		is_day_counted = false

func sell_item(item):
	# Check if enough money
	if(money - item.price < 0):
		UI.ui_message_popup.window_title = "Uff not enough money sorry :("
		var label = Label.new()
		label.text = "ahh there is some money missing sorry I can't sell you that :("
		UI.ui_message_popup.add_child(label)
		# Shop pop up if not enough
		UI.ui_message_popup.popup()
		return	
	# If enough subtract money
	money = money - item.price
	# Update money UI
	UI.ui_money.text = str(money)
	# And add item to shack
	var new_item = Item.instance()
	new_item.copy_item(item)
	new_item.price = 0
	Shack.items.add_child(new_item)
	# Update shack UI
	Shack.generate_UI()
	
func equip_tool(tool_to_equip):
	current_tool = tool_to_equip
	emit_signal("tool_equiped")
	print('eqiped new tool: ', current_tool)
	
func equip_plant(plant_to_equip):
	current_plant = plant_to_equip.to_lower()
	emit_signal("plant_equiped")
	print('eqiped new plant: ', current_plant)

func change_ground(cell_position, new_type):
	tiles_ground.set_cellv(cell_position, tiles_ground_ids.find(new_type))		

func change_plant_layer(cell_position, plant_name):
	# check if there is a plant allready
	if(!PlantLayer.is_plant_on_position(cell_position)):
		PlantLayer.instsance_plant(cell_position, plant_name)
