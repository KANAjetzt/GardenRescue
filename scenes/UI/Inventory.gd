extends Control

signal pressed_slot(item_name)

export(PackedScene) var Slot
export(NodePath) var grid_path
onready var grid = get_node(grid_path)

func _ready():
	hide()

func populate(slots):
	for slot in slots:
		grid.add_child(slot)
		
func get_slot_by_item_name(item_name):
	for slot in grid.get_children():
		if (slot.item_name == item_name):
			return slot

func remove_slot_by_item_name(item_name):
	var slot = get_slot_by_item_name(item_name)
	grid.remove_child(slot)

func _on_Button_pressed():
	hide()
	
func _on_pressed_slot(item_name):
	emit_signal("pressed_slot", item_name)
