extends Control

signal pressed_slot(item_id)
signal closed

export(PackedScene) var Slot
export(NodePath) var grid_path
onready var grid = get_node(grid_path)

func _ready():
	hide()
	

func populate(slots):
	for slot in slots:
		slot.connect("pressed_slot", self, "_on_pressed_slot")
		grid.add_child(slot)
		
func get_slot(item_id: String):	
	var get_slot = null
	
	for slot in grid.get_children():
		if (slot.unique_id == item_id):
			get_slot = slot

	return get_slot

func remove_slot(item_id):
	var slot = get_slot(item_id)	
	grid.remove_child(slot)

func clear_slots():
	for slot in grid.get_children():
		slot.queue_free()

func get_new_slot(item):
	var new_slot = Slot.instance()
	new_slot.unique_id = item.unique_id
	new_slot.display_name = item.display_name
	new_slot.icon = item.icon
	new_slot.amount = item.amount
	
	return new_slot

func _on_Button_pressed():
	emit_signal("closed")
	hide()
	
func _on_pressed_slot(id):
	print("pressed_slot - unique_id: ", id)
	emit_signal("pressed_slot", id)
