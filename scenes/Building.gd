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
	# clear UI
	$UiShack.clear_grid()
	$UiShack.populate_grid(items.get_children())

func is_item_existing(item_name):
	var is_item = false

	for i in items.get_children():
		if(i.item_name == item_name):
			is_item = true
			break
	
	return is_item

func get_item(item_name):
	for i in items.get_children():
		if(i.item_name == item_name):
			return i

func add_item(item):
	# check if stackable and check if item exists already
	print("add item to shack: ", is_item_existing(item.item_name))
	if(item.is_stackable && is_item_existing(item.item_name)) :
			# if so find it
			var old_item = get_item(item.item_name)
			# and update the amount
			old_item.amount += item.amount
	else:
		# if not add a new item
		items.add_child(item)
		
	# Update UI
	generate_UI()

func _on_Building_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("ui_select"):
		$UiShack.popup()
		
func _on_btn_pressed(label):
	emit_signal("ui_btn_pressed", label)
