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
	
	inventory.connect("item_changed", self, "_on_item_changed")
	
	# If the building has someting in inventory
	if(items):
		for item in items:
			inventory.add_item(item.unique_id, item.amount)

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

func _on_item_changed(id, is_added):
	if(is_added):
		# add slot
		var item = ItemDatabase.get_item_data(id)
		var slot = ui_inventory.get_slot(id)
		var amount = inventory.get_amount(id)
		
		# Lets add the inventory amount to te itemData
		# Because I use the itemData to create a new inventory slot 
		# But the actuall harvested amount is stored only in the inventory
		item.amount = amount
		
		if(!item.is_stackable || !slot):
			var new_slot = ui_inventory.get_new_slot(item)
			ui_inventory.populate([new_slot])
		else:
			print("update_amount! - ", amount)
			slot.update_amount(amount)
	else:
		# remove slot
		ui_inventory.remove_slot(id)
