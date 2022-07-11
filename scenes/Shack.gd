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
	
	GameWorld.equip_tool(clicked_item)
