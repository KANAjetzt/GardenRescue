extends Node

# Stores the type and location of all plants.
# This uses the PlantLayer TileMap.
# One cell contains the position_x, position_y and cell index that is used to reference
# the scene array on the PlantLayer TileMap Node.

var cells = []

func update(new_cells_data):
	cells = new_cells_data

func get_cells():
	return cells
