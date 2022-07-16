extends Control

onready var GameWorld = get_node("/root/GameWorld")

export (NodePath) var ui_current_tool_path
onready var ui_current_tool = get_node(ui_current_tool_path)
export (NodePath) var ui_current_day_path
onready var ui_current_day = get_node(ui_current_day_path)
export (NodePath) var ui_money_path
onready var ui_money = get_node(ui_money_path)
export (NodePath) var ui_message_popup_path
onready var ui_message_popup = get_node(ui_message_popup_path)

func _ready():
	GameWorld.connect("tool_equiped", self, "_on_tool_equiped")
	GameWorld.connect("plant_equiped", self, "_on_plant_equiped")
	GameWorld.connect("new_day", self, "_on_new_day")
	ui_money.text = str("Money: ", GameWorld.money)
	
	GameWorld.UI = self

func _on_new_day(day):
	ui_current_day.text = str("Its day: ", day)

func _on_tool_equiped():
	# show current tool in UI
	
	ui_current_tool.texture = GameWorld.current_tool.icon
#	Input.set_custom_mouse_cursor(GameWorld.current_tool.icon)
		
func _on_plant_equiped():
	# show current tool in UI
	var current_plant_texture
	
	print(GameWorld.plants_store)
	
	for i in GameWorld.plants_store:
		if(i.name.to_lower() == GameWorld.current_plant.to_lower()):
			current_plant_texture = i.shop_icon
	
	if(current_plant_texture):
		Input.set_custom_mouse_cursor(current_plant_texture)

func update_money():
	ui_money.text = str(GameWorld.money)
