extends Control

onready var GameWorld = get_node("/root/GameWorld")

export (NodePath) var ui_current_tool_path
onready var ui_current_tool = get_node(ui_current_tool_path)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameWorld.connect("tool_equiped", self, "_on_tool_equiped")


func _on_tool_equiped():
	# show current tool in UI
	var current_tool_texture
	
	for i in GameWorld.tools_shack:
		if(i.name.to_lower() == GameWorld.current_tool.to_lower()):
			current_tool_texture = i.sprite_texture
	
	if(current_tool_texture):
		ui_current_tool.texture = current_tool_texture
		Input.set_custom_mouse_cursor(current_tool_texture)
