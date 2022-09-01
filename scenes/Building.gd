extends Area2D

signal clicked_on_building
signal ui_btn_pressed(label)

export(Texture) var texture
export(Texture) var texture_night
export(NodePath) var ui_inventory_path
onready var ui_inventory = get_node(ui_inventory_path)

export(Array, Resource) var items

var inventory: Inventory = Inventory.new()

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	GameWorld.connect("sunrise", self, "_on_sunrise")
	GameWorld.connect("sunset", self, "_on_sunset")
	
	$Sprite.texture = texture
	
	for item in items:
		inventory.add_item(item.unique_id, item.amount)
	
	print("items: ", items)
	init_ui(items)

func get_iventory_slot(new_items):
	var slots = []
	
	print("new_items: ", new_items)
	
	for item in new_items:
		var new_slot = ui_inventory.Slot.instance()
		new_slot.unique_id = item.unique_id
		new_slot.display_name = item.display_name
		new_slot.icon = item.icon
		new_slot.amount = item.amount
		new_slot.connect("pressed_slot", self, "_on_Inventory_pressed_slot")
		slots.append(new_slot)
	
	return slots

func init_ui(items):
	print("init_ui - items: ", items)
	var slots = get_iventory_slot(items)
	ui_inventory.populate(slots)

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
	if(item.is_stackable && is_item_existing(item.item_name)):
		# if so find it
		var old_item = get_item(item.item_name)
		# and update the amount
		old_item.amount += item.amount
		# Update UI
		var slot = inventory.get_slot_by_item_name(item.item_name)
		slot.update_amount(old_item.amount)
	else:
		# if not add a new item
		items.add_child(item)
		# Update UI
		var slots = get_iventory_slot([item])
		inventory.populate(slots)

func remove_item(item):
	# Update Inventory UI
	inventory.remove_slot_by_item_name(item.item_name)
	# Remove item
	item.free()

func _on_Building_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("ui_select"):
		emit_signal("clicked_on_building")
		
func _on_btn_pressed(label):
	emit_signal("ui_btn_pressed", label)
	
func _on_sunrise():
	$Sprite.texture = texture

func _on_sunset():
	if(!texture_night):
		return
	$Sprite.texture = texture_night
