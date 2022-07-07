extends VBoxContainer

export(Texture) var btn_texture
export(String) var btn_label
export(String, 'tool', 'seed') var type

onready var GameWorld = get_node("/root/GameWorld")

func setup_btn():
	$TextureButton.texture_normal = btn_texture
	$Label.text = btn_label


func _on_TextureButton_pressed():
	if(type == 'tool'):
		GameWorld.equip_tool(btn_label)
	elif(type == 'seed'):
		GameWorld.equip_plant(btn_label)
