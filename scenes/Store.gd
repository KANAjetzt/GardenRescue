extends "res://scenes/Building.gd"

var clicked_item

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	.init_ui()

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
	# If enough subtract money
	GameWorld.money = GameWorld.money - item.price
	# Update money UI
	GameWorld.UI.ui_money.text = str(GameWorld.money)
	# Add item to shack
	var new_item = GameWorld.Item.instance()
	new_item.copy_item(item)
	new_item.price = 0
	GameWorld.Shack.add_item(new_item)
	# Remove item from shop if one time purchase
	if(item.is_one_time_purchase):
		.remove_item(item)

func _on_Store_clicked_on_building():
	inventory.show()

func _on_Inventory_pressed_slot(item_name):
	# get clicked item
	for item in items.get_children():
		if(item.item_name == item_name):
			clicked_item = item
			sell_item(clicked_item)
