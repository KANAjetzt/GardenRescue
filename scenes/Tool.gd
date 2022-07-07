extends Node2D

export(Texture) var texture
export(String, "Store", "Shack") var location

onready var GameWord = get_node("/root/GameWorld")

func _ready():
	hide()
	$Sprite.texture = texture
