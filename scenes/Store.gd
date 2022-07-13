extends "res://scenes/Building.gd"

var clicked_item

onready var GameWorld = get_node("/root/GameWorld")

func _on_Store_ui_btn_pressed(label):
	# get clicked item
	for item in items.get_children():
		if(item.item_name == label):
			clicked_item = item
			sell_item(clicked_item)

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
	# And add item to shack
	var new_item = GameWorld.Item.instance()
	new_item.copy_item(item)
	new_item.price = 0
	GameWorld.Shack.items.add_child(new_item)
	# Update shack UI
	GameWorld.Shack.generate_UI()























