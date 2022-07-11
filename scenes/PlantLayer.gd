extends TileMap

const plant = preload("res://scenes/Grass.tscn")

onready var GameWorld = get_node("/root/GameWorld")

# Called when the node enters the scene tree for the first time.
func _ready():
	GameWorld.PlantLayer = self
	
	for cellpos in get_used_cells():
		var cell = get_cellv(cellpos)
		if cell == 0:
			instsance_plant(cellpos, plant)
			
func instsance_plant(cellpos, plant_scene):
	var object = plant_scene.instance()
	object.position = map_to_world(cellpos)
	add_child(object)
	set_cellv(cellpos, -1)
