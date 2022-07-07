extends VBoxContainer

export(Texture) var btn_texture
export(String) var btn_label

onready var GameWorld = get_node("/root/GameWorld")

func setup_btn():
	$TextureButton.texture_normal = btn_texture
	$Label.text = btn_label


func _on_TextureButton_pressed():
	GameWorld.equip_tool(btn_label)
