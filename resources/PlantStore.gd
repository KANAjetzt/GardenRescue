class_name PlantStore
extends Resource
# Stores the type and location of all plants.
# This uses the PlantLayer TileMap.
# One cell contains the position_x, position_y and cell index that is used to reference
# the scene array on the PlantLayer TileMap Node.
# To actually save the state of each plant we also need so save the plant age and plant stage index.
# With that we can re instance all the plants

signal loaded_plants(plants)

var plants = []

func add_plant(plant):
	plants.append(plant)

func get_plant(grid_pos):
		for plant in plants:
			if(plant.grid_position == grid_pos):
				return plant

func remove_plant(plant):
	plants.remove(plants.find(plant))
	return plants

func clear():
	plants = []
	
func generate_JSON_dict(): 
	var save = []
	
	for plant in plants:
		save.append({
			"pos": {
				"x": plant.grid_position.x,
				"y": plant.grid_position.y,
			},
			"name": plant.plant_name,
			"stage": plant.stage_index,
			"age": plant.age
		})
	
	return save

func load_plants(save_data):
	emit_signal("loaded_plants", save_data)
