extends Popup

onready var GameWorld = get_node("/root/GameWorld")

export(PackedScene) var tool_grid_item
export (NodePath) var tool_grid_path
onready var tool_grid = get_node(tool_grid_path)


func _ready():
	hide()

func populate_grid(items, texture_property):
	for i in items:
		var new_grid_item = tool_grid_item.instance()
		new_grid_item.btn_texture = i[texture_property]
		new_grid_item.btn_label = i.name
		if("stage" in i):
			new_grid_item.type = i.stage
			print("populate grid: ", i)
		else:
			new_grid_item.type = 'tool'
		new_grid_item.setup_btn()
		tool_grid.add_child(new_grid_item)
