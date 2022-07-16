extends Popup

onready var GameWorld = get_node("/root/GameWorld")

export(PackedScene) var tool_grid_item
export (NodePath) var tool_grid_path
onready var tool_grid = get_node(tool_grid_path)

var clicked_item = null

signal btn_pressed(btn_label)

func _ready():
	hide()

func clear_grid():
	pass

func populate_grid(items):
	print("populating inventory: ", items)
	
	for i in items:
		tool_grid.add_item(i.item_name, i.icon)
		
		
#		var new_grid_item = tool_grid_item.instance()
#		new_grid_item.connect("btn_pressed", self, "_on_btn_pressed")
#		new_grid_item.btn_texture = i.icon
#		new_grid_item.btn_label = i.item_name
#		new_grid_item.price = i.price
#		new_grid_item.amount = i.amount
#		new_grid_item.setup_btn()
#		tool_grid.add_child(new_grid_item)
		
func _on_btn_pressed(label):
	emit_signal("btn_pressed", label)
