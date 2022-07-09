extends "res://scenes/Building.gd"

var clicked_item

onready var GameWorld = get_node("/root/GameWorld")

func _on_Store_ui_btn_pressed(label):
	# get clicked item
	for item in items.get_children():
		if(item.item_name == label):
			clicked_item = item
			GameWorld.sell_item(clicked_item)
