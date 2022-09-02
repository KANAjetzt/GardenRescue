extends "res://scenes/Building.gd"
var clicked_item


func _ready():
	print("ready store: ", items)

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
