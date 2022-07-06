extends Node


export(Texture) var sprite_texture

func _ready():
	$Sprite.texture = sprite_texture
