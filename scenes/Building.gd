extends Area2D

export(Texture) var texture

export(NodePath) var items_path
onready var items = get_node(items_path)

signal ui_btn_pressed(label)

func _ready():
	$Sprite.texture = texture
	generate_UI()
	$UiShack.connect("btn_pressed", self, "_on_btn_pressed")

func generate_UI():
	$UiShack.populate_grid(items.get_children())

func _on_Building_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("ui_select"):
		$UiShack.popup()
		
func _on_btn_pressed(label):
	emit_signal("ui_btn_pressed", label)
