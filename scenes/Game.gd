extends Node

export (NodePath) var ui_shack_path
onready var ui_shack = get_node(ui_shack_path)




func _on_Shack_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("ui_select"):
		ui_shack.show()
