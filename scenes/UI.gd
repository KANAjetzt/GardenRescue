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
export (NodePath) var ui_time_settings_popup_path
onready var ui_time_settings_popup = get_node(ui_time_settings_popup_path)
onready var animation_money_added = $CanvasLayer/TopLeft/MarginContainer/VBC/Money/AnimationMoneyAdded


func _ready():
	GameWorld.connect("tool_equiped", self, "_on_tool_equiped")
	GameWorld.connect("tool_unequiped", self, "_on_tool_unequiped")
	GameWorld.connect("plant_equiped", self, "_on_plant_equiped")
	GameWorld.connect("new_day", self, "_on_new_day")
	ui_money.text = str(GameWorld.money)
	ui_current_day.text = str("It's day: ", GameWorld.day_count)
	
	GameWorld.UI = self

func _on_new_day(day):
	ui_current_day.text = str("It's day: ", day)

func _on_tool_equiped():
	# Show current tool in UI
	ui_current_tool.update_icon(GameWorld.current_tool.icon)
	
	# Check if tool has an amount
	if(GameWorld.current_tool.amount <= 0):
		ui_current_tool.update_amount(0)
		return
	
	ui_current_tool.update_amount(GameWorld.current_tool.amount)
	
#	Input.set_custom_mouse_cursor(GameWorld.current_tool.icon)

func _on_tool_unequiped():
	ui_current_tool.update_amount(0)
	ui_current_tool.update_icon(null)

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
	animation_money_added.play("Wave")


func _on_TimeSetting_pressed():
	ui_time_settings_popup.popup()


func _on_Time_Settings_HSlider_value_changed(value):
	$CanvasLayer/TimeSettings/Value.text = str(value)
	GameWorld.time_multiplier = value


func _on_GroundLayer_seed_used(seed_item):
	if(!seed_item):
		return
	
	ui_current_tool.update_amount(seed_item.amount)
