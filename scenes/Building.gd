extends Area2D

signal clicked_on_building
signal ui_btn_pressed(label)

export(Texture) var texture
export(Texture) var texture_night
export(NodePath) var ui_inventory_path
onready var ui_inventory = get_node(ui_inventory_path)
export(Resource) var inventory
export(Array, Resource) var items

func _ready():
	GameWorld.connect("sunrise", self, "_on_sunrise")
	GameWorld.connect("sunset", self, "_on_sunset")
	
	$Sprite.texture = texture		
	
	inventory.connect("item_changed", self, "_on_item_changed")
	inventory.connect("loaded", self, "_on_inventory_loaded")
	
	# If the building has someting in inventory
	if(items):
		for item in items:
			inventory.add_item(item.unique_id, item.price)

func get_iventory_slot(new_items):
	var slots = []
	
	for item_key in new_items.keys():
		var item = ItemDatabase.get_item_data(item_key)
		
		var new_slot = ui_inventory.get_new_slot(item)
		new_slot.connect("pressed_slot", self, "_on_Inventory_pressed_slot")
		slots.append(new_slot)
	
	return slots

func is_item_existing(item_id):
	var item = ItemDatabase.get_item_data(item_id)
	if(item):
		return true
	else:
		return false

func get_item(item_name):
	for i in items.get_children():
		if(i.item_name == item_name):
			return i

func add_item(item):
	inventory

func remove_item(item):
	inventory.remove_item(item.unique_id)

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

func _on_item_changed(id, is_added):
	var item = ItemDatabase.get_item_data(id)
	var slot = ui_inventory.get_slot(id)
	var amount = inventory.get_amount(id)
	
	if(is_added):
		if(!item.is_stackable || !slot):
			var new_slot = ui_inventory.get_new_slot(item)
			new_slot.update_amount(amount)
			ui_inventory.populate([new_slot])
		else:
			print("update_amount! - ", amount)
			slot.update_amount(amount)
			
		return
	
	if(amount < 0):
		# remove slot
		ui_inventory.remove_slot(id)
		return

func _on_inventory_loaded(items):
	# clear inventory
	inventory.clear()
	ui_inventory.clear_slots()
	
	for item_id in items.keys():
		var count = items[item_id]
		inventory.add_item(item_id, count)
