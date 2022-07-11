extends TileMap

onready var GameWorld = get_node("/root/GameWorld")

export(Array, String) var plant_names
export(Array, PackedScene) var plants
export(NodePath) var plant_store_path
onready var plant_store = get_node(plant_store_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	GameWorld.PlantLayer = self
	
	for cellpos in get_used_cells():
		var cell = get_cellv(cellpos)
		if (plants[cell]):
			instsance_plant(cellpos, plant_names[cell])
			
func instsance_plant(cellpos, plant_name):
	var plant_scene = plants[plant_names.find(plant_name)] 
	var object = plant_scene.instance()
	object.position = map_to_world(cellpos)
	plant_store.add_child(object)
	set_cellv(cellpos, plant_names.find(plant_name))

func is_plant_on_position(cellpos):
	if(get_cellv(cellpos) == -1):
		return false
	else:
		return true
