extends CanvasLayer

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
onready var animation_money_added = $TopLeft/MarginContainer/VBC/Money/AnimationMoneyAdded


func _ready():
	GameWorld.connect("tool_equiped", self, "_on_tool_equiped")
	GameWorld.connect("tool_unequiped", self, "_on_tool_unequiped")
	GameWorld.connect("plant_equiped", self, "_on_plant_equiped")
	GameWorld.connect("new_day", self, "_on_new_day")
	ui_money.text = str(GameWorld.get_money())
	ui_current_day.text = str("It's day: ", GameWorld.gameStore.day_count)
	
	GameWorld.UI = self

func _on_new_day(day):
	ui_current_day.text = str("It's day: ", day)

func _on_tool_equiped():
	# Get current tool amount from shack iventory
	var current_tool_data = GameWorld.get_current_tool()
	var amount = GameWorld.Shack.inventory.get_amount(current_tool_data.unique_id)
	
	# Show current tool in UI
	ui_current_tool.update_icon(current_tool_data.icon)
	
	# Check if tool has an amount
	if(amount <= 0):
		ui_current_tool.update_amount(0)
		return
	
	ui_current_tool.update_amount(amount)
	
#	Input.set_custom_mouse_cursor(GameWorld.get_current_tool().icon)

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
	ui_money.text = str(GameWorld.get_money())
	animation_money_added.play("Wave")


func _on_TimeSetting_pressed():
	ui_time_settings_popup.popup()


func _on_Time_Settings_HSlider_value_changed(value):
	$TimeSettings/Value.text = str(value)
	GameWorld.update_time_multiplier(value)


func _on_GroundLayer_seed_used(seed_item):
	if(!seed_item):
		return
	
	ui_current_tool.update_amount(GameWorld.Shack.inventory.get_amount(seed_item.unique_id))
