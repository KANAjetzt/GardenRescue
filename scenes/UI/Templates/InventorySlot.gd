extends TextureButton

signal pressed_slot(unique_id)

export var clickable = true

var unique_id
var display_name
var icon
var amount = 0

func _ready():
	$Icon.texture = icon
	if(amount > 0):
		$Amount/Label.text = str(amount)
	else:
		$Amount.hide()
	
	# Remove pointing hand cursor and hover effect if not clickable
	if(!clickable):
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		texture_hover = null


func update_amount(new_amount):
	amount = new_amount
	
	if(amount > 0):
		$Amount.show()
		$Amount/Label.text = str(amount)
	else:
		$Amount.hide()

func add_amount(ammount_to_add):
	# Make sure it's vissible
	$Amount.show()
	
	# Add amount
	amount += ammount_to_add
	# Update label
	$Amount/Label.text = str(amount)
	
func update_icon(new_icon):
	if(!new_icon):
		icon = null
		$Icon.texture = null
		return 
		
	icon = new_icon
	$Icon.texture = icon

func _on_InventorySlot_pressed():
	emit_signal("pressed_slot", unique_id)
