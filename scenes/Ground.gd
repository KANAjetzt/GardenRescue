extends TileMap

onready var GameWorld = get_node("/root/GameWorld")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var global_mouse_position = get_global_mouse_position()
			var clicked_cell_position = world_to_map(to_local(global_mouse_position))
			var clicked_cell_id = get_cellv(clicked_cell_position)
			
			print(global_mouse_position, clicked_cell_position, clicked_cell_id)

			if(!GameWorld.current_tool):
				return
			
			print("current_tool type: ", GameWorld.current_tool.type)
			if(GameWorld.current_tool.item_name.to_lower() == 'shovel'):
				GameWorld.change_ground(clicked_cell_position, 'soil')
				GameWorld.change_plant_layer(clicked_cell_position, '')
			
			match clicked_cell_id:
				0: 
					print("grassDead")
					if(GameWorld.current_tool.type.to_lower() == 'seed'):
						GameWorld.change_plant_layer(clicked_cell_position, GameWorld.current_tool.item_name)
						
				1: print("grassLight")
				2: 
					print("grassLightHeigh")
					if(GameWorld.current_tool.item_name.to_lower() == 'lawn mower'):
						GameWorld.change_ground(clicked_cell_position, 'grassLight')
				3: 
					print("plantDead")
					if(GameWorld.current_tool.item_name.to_lower() == 'gloves'):
						GameWorld.change_ground(clicked_cell_position, 'soil')

func _ready():
	GameWorld.GroundLayer = self
	
func init_grass():
	for cellpos in get_used_cells():
		var cell = get_cellv(cellpos)
		if (cell == GameWorld.tiles_ground_ids.find("grassLightHeigh")):
			GameWorld.PlantLayer.instsance_plant(cellpos, "grass", 4)
