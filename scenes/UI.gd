extends Control

onready var GameWorld = get_node("/root/GameWorld")

export (NodePath) var ui_current_tool_path
onready var ui_current_tool = get_node(ui_current_tool_path)


func _ready():
	GameWorld.connect("tool_equiped", self, "_on_tool_equiped")
	GameWorld.connect("plant_equiped", self, "_on_plant_equiped")

func _on_tool_equiped():
	# show current tool in UI
	var current_tool_texture
	
	for i in GameWorld.tools_shack:
		if(i.name.to_lower() == GameWorld.current_tool.to_lower()):
			current_tool_texture = i.texture
	
	if(current_tool_texture):
		ui_current_tool.texture = current_tool_texture
		Input.set_custom_mouse_cursor(current_tool_texture)
		
func _on_plant_equiped():
	# show current tool in UI
	var current_plant_texture
	
	print(GameWorld.plants_store)
	
	for i in GameWorld.plants_store:
		if(i.name.to_lower() == GameWorld.current_plant.to_lower()):
			current_plant_texture = i.shop_icon
	
	if(current_plant_texture):
		Input.set_custom_mouse_cursor(current_plant_texture)
