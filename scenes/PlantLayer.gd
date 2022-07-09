extends TileMap

const plant = preload("res://scenes/Grass.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	for cellpos in get_used_cells():
		var cell = get_cellv(cellpos)
		if cell == 0:
			var object = plant.instance()
			object.position = map_to_world(cellpos)
			add_child(object)
			set_cellv(cellpos, -1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
