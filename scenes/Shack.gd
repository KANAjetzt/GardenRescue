extends "res://scenes/Building.gd"

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	GameWorld.Shack = self

func generate_UI():
	.generate_UI()


func _on_Shack_ui_btn_pressed(label):
	var clicked_item
	
	for i in $Items.get_children():
		if(i.item_name == label):
			clicked_item = i
	
	# Check if itam has price
	if(clicked_item.price > 0):
		# Add money
		GameWorld.money = GameWorld.money + clicked_item.price
		# Remove item from shack
		clicked_item.free()
		# Update shack UI
		generate_UI()
		# Update money UI
		GameWorld.UI.update_money()
		return
		
	
	GameWorld.equip_tool(clicked_item)
