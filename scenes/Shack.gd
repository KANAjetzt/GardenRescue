extends "res://scenes/Building.gd"

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	GameWorld.Shack = self
	print("ready shack: ", items)
	.init_ui()


func sell_item(item):
	# Play sell sound
	GameWorld.Audio.play_sfx_random_pitch("Sell")
	# Add money
	GameWorld.money = GameWorld.money + item.price * item.amount
	# Update money UI
	GameWorld.UI.update_money()
	.remove_item(item)

func _on_Shack_clicked_on_building():
	GameWorld.Audio.play_sfx("DoorOpen")
	inventory.show()

func _on_Inventory_pressed_slot(item_name):
	var clicked_item = .get_item(item_name)
	
	# Check if itam has price
	if(clicked_item.price > 0):
		sell_item(clicked_item)
		return
	
	GameWorld.equip_tool(clicked_item)
