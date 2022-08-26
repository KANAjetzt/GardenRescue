extends "res://scenes/Building.gd"

var clicked_item

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	init_ui()

func get_iventory_slot(new_items):
	var slots = []

	for item in new_items:
		var new_slot = inventory.Slot.instance()
		new_slot.item_name = item.item_name
		new_slot.icon = item.icon
		new_slot.amount = item.price
		new_slot.connect("pressed_slot", self, "_on_Inventory_pressed_slot")
		slots.append(new_slot)
	
	return slots

func init_ui():
	var slots = get_iventory_slot(items.get_children())
	inventory.populate(slots)

func sell_item(item):
		# Check if enough money
	if(GameWorld.money - item.price < 0):
		GameWorld.UI.ui_message_popup.window_title = "Uff not enough money sorry :("
		var label = Label.new()
		label.text = "ahh there is some money missing sorry I can't sell you that :("
		GameWorld.UI.ui_message_popup.add_child(label)
		# Shop pop up if not enough
		GameWorld.UI.ui_message_popup.popup()
		return	
	# If enough 
	
	# Play SFX
	GameWorld.Audio.play_sfx("Buy")
	
	# Subtract money
	GameWorld.money = GameWorld.money - item.price
	# Update money UI
	GameWorld.UI.ui_money.text = str(GameWorld.money)
	# Add item to shack
	var new_item = GameWorld.Item.instance()
	new_item.copy_item(item)
	new_item.price = 0
	GameWorld.Shack.add_item(new_item)
	# Equip item
	GameWorld.equip_tool(new_item)
	# Remove item from shop if one time purchase
	if(item.is_one_time_purchase):
		.remove_item(item)

func _on_Store_clicked_on_building():
	inventory.show()
	GameWorld.Audio.play_sfx("WoodKnock")

func _on_Inventory_pressed_slot(item_name):
	# get clicked item
	for item in items.get_children():
		if(item.item_name == item_name):
			clicked_item = item
			sell_item(clicked_item)
