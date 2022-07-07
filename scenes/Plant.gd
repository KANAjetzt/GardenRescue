extends Node2D

export(Texture) var shop_icon
export(String, "Store", "Shack") var location = "Store"
export(String, "seed", "seedling", "sprouting", "fruit") var stage

func _ready():
	hide()
	$ShopIcon.texture = shop_icon
