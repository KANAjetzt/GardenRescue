extends TileMap

onready var GameWorld = get_node("/root/GameWorld")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var global_mouse_position = get_global_mouse_position()
			var clicked_cell_position = world_to_map(to_local(global_mouse_position))
			var clicked_cell_id = get_cellv(clicked_cell_position)
			
			print(global_mouse_position, clicked_cell_position, clicked_cell_id)
			
			match clicked_cell_id:
				0: print("grassDead")
				1: print("grassLight")
				2: 
					print("grassLightHeigh")
					if(GameWorld.current_tool == 'lawnmower'):
						GameWorld.change_ground(clicked_cell_position, 'grassLight')
				3: 
					print("plantDead")
					if(GameWorld.current_tool == 'gloves'):
						GameWorld.change_ground(clicked_cell_position, 'grassDead')

func _ready():
	GameWorld.tiles_ground = self