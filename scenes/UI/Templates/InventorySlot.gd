extends TextureButton

signal pressed_slot(item_name)

var item_name
var icon
var amount = 0

func _ready():
	$Icon.texture = icon
	if(amount > 0):
		$Amount/Label.text = str(amount)
	else:
		$Amount.hide()


func update_amount(new_amount):
	amount = new_amount
	# Update label
	$Amount/Label.text = str(amount)

func add_amount(ammount_to_add):
	# Make sure it's vissible
	$Amount.show()
	
	# Add amount
	amount += ammount_to_add
	# Update label
	$Amount/Label.text = str(amount)
	

func _on_InventorySlot_pressed():
	emit_signal("pressed_slot", item_name)
