extends "res://scenes/Building.gd"
var clicked_item


func _ready():
	print("ready store: ", items)
#	init_ui()

func get_iventory_slot(new_items):
	var slots = []

	for item in new_items:
		var new_slot = ui_inventory.Slot.instance()
		new_slot.display_name = item.display_name
		new_slot.icon = item.icon
		new_slot.amount = item.price
		new_slot.connect("pressed_slot", self, "_on_Inventory_pressed_slot")
		slots.append(new_slot)
	
	return slots

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
	ui_inventory.show()
	GameWorld.Audio.play_sfx("WoodKnock")

func _on_Inventory_pressed_slot(item_id):
	print("item_id: ", item_id)
	# get clicked item
	for item in items:
		if(item.unique_id == item_id):
			clicked_item = item
			sell_item(clicked_item)
