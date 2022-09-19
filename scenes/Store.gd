extends "res://scenes/Building.gd"
var clicked_item


func _ready():
	print("ready store: ", items)

func sell_item(item):
	# Check if enough money
	if(GameWorld.get_money() - item.price < 0):
		
		GameWorld.UI.show_message_popup(
			"Uff not enough money sorry :(",
			"Ahh there is some money missing sorry I can't sell you that :("
			)
		return
	# If enough 
	
	# Play SFX
	GameWorld.Audio.play_sfx("Buy")
	
	if(item.unique_id == "tool_lawnMower"):
		GameWorld.UI.show_message_popup(
			"WOW :D",
			"You Completed the Game! :D Thank you so much for playing! Let me know what you think in the comments :) I added something special to you'r shack :D"
			)
		# Subtract money
		GameWorld.remove_money(item.price)
		# Update money UI
		GameWorld.UI.ui_money.text = str(GameWorld.get_money())
		# Add item to shack
		GameWorld.Shack.inventory.add_item("fruid_happy_potato", 1)
		return

	# Subtract money
	GameWorld.remove_money(item.price)
	# Update money UI
	GameWorld.UI.ui_money.text = str(GameWorld.get_money())
	# Add item to shack
	GameWorld.Shack.inventory.add_item(item.unique_id, item.amount)
	# Equip item
	GameWorld.equip_tool(item)
	# Remove item from shop if one time purchase
	if(item.is_one_time_purchase):
		inventory.remove_item(item.unique_id)

func _on_Store_clicked_on_building():
	ui_inventory.show()
	GameWorld.Audio.play_sfx("WoodKnock")

func _on_Inventory_pressed_slot(item_id):
	print("item_id: ", item_id)
	# get clicked item
	var item = ItemDatabase.get_item_data(item_id)
	sell_item(item)

func _on_item_changed(id, is_added):
	._on_item_changed(id, is_added)
	
	var slot = ui_inventory.get_slot(id)
	if(slot):
		slot.update_amount(ItemDatabase.get_item_data(id).price)
		
func _on_inventory_loaded(items):
	# clear inventory
	inventory.clear()
	ui_inventory.clear_slots()
		
	for item_id in items.keys():
		var item = ItemDatabase.get_item_data(item_id)
		inventory.add_item(item.unique_id, item.price)
