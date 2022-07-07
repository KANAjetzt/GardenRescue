extends Popup

onready var GameWorld = get_node("/root/GameWorld")

export(PackedScene) var tool_grid_item
export (NodePath) var tool_grid_path
onready var tool_grid = get_node(tool_grid_path)


func _ready():
	hide()
	populate_tool_grid()

func populate_tool_grid():
	print("populate_tool_grid: ", GameWorld.tools_shack)
	for i in GameWorld.tools_shack:
		var new_grid_item = tool_grid_item.instance()
		new_grid_item.btn_texture = i.sprite_texture
		new_grid_item.btn_label = i.name
		new_grid_item.setup_btn()
		print("populate_tool_grid: ", new_grid_item)
		tool_grid.add_child(new_grid_item)
