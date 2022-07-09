extends VBoxContainer

export(Texture) var btn_texture
export(String) var btn_label

var price
var amount

onready var GameWorld = get_node("/root/GameWorld")

signal btn_pressed(btn_label)

func setup_btn():
	$TextureButton.texture_normal = btn_texture
	$Label.text = btn_label
	
	# Check if shop
	if(price):
		$Amount.text = str(amount)
		$Price.text = str(price)
	else:
		$Amount.hide()
		$Price.hide()


func _on_TextureButton_pressed():
	emit_signal("btn_pressed", btn_label)
