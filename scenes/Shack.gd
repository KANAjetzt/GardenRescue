extends Area2D

export(Texture) var texture

export(NodePath) var items_path
onready var items = get_node(items_path)
export(String) var texture_property

func _ready():
	$Sprite.texture = texture
	$UiShack.populate_grid(items.get_children(), texture_property)

func _on_Building_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("ui_select"):
		$UiShack.popup()
