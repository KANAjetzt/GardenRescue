extends "res://scenes/Building.gd"

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	GameWorld.Shack = self

func generate_UI():
	.generate_UI()

func sell_item(item):
	# Add money
	GameWorld.money = GameWorld.money + item.price * item.amount
	# Remove item from shack
	item.free()
	# Update shack UI
	generate_UI()
	# Update money UI
	GameWorld.UI.update_money()

func _on_Shack_ui_btn_pressed(label):
	var clicked_item = .get_item(label)
	
	# Check if itam has price
	if(clicked_item.price > 0):
		sell_item(clicked_item)
		return
	
	GameWorld.equip_tool(clicked_item)
