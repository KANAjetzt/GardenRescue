extends TileMap

export(Array, String) var tile_names

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
			
			if(GameWorld.current_tool.item_name.to_lower() == 'shovel'):
				GameWorld.Audio.play_sfx('ShovelDig')
				GameWorld.change_plant_layer(clicked_cell_position, '')
				return

			match tile_names[clicked_cell_id]:
				"soil":
					if(GameWorld.current_tool.type.to_lower() == 'seed'):
						GameWorld.change_plant_layer(clicked_cell_position, GameWorld.current_tool.item_name)
			
			

func _ready():
	GameWorld.GroundLayer = self
