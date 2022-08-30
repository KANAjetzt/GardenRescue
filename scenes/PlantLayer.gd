extends TileMap

onready var GameWorld = get_node("/root/GameWorld")

export(PackedScene) var Item
export(Array, String) var plant_names
export(Array, PackedScene) var plants
export(NodePath) var plant_store_path
onready var plant_store = get_node(plant_store_path)
export(NodePath) var shack_items_path
onready var shack_items = get_node(shack_items_path)

onready var harvest_particles = GameWorld.paticles.get_particle("Harvest")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var global_mouse_position = get_global_mouse_position()
			var clicked_cell_position = world_to_map(to_local(global_mouse_position))
			var clicked_cell_id = get_cellv(clicked_cell_position)
			
			print(global_mouse_position, clicked_cell_position, clicked_cell_id)
			
			# if there is no tool selected
			if(!GameWorld.current_tool):
				return
			
			# if there is no plant on this position
			if(!is_plant_on_position(clicked_cell_position)):
				return
			
			match GameWorld.current_tool.item_name.to_lower():
				'scissors':
					handleHarvest(clicked_cell_position)
				'hand':
					if(get_plant(clicked_cell_position).harvest_count <= 0):
						handleHarvest(clicked_cell_position)
				

func _ready():
	hide()
	GameWorld.PlantLayer = self
	
	for cellpos in get_used_cells():
		var cell = get_cellv(cellpos)
		if (plants[cell]):
			# Instance plant at max stage if grass
			if(plant_names[cell].to_lower() == "grass"):
				instsance_plant(cellpos, plant_names[cell], 4)
			else:
				instsance_plant(cellpos, plant_names[cell])
			
func instsance_plant(cellpos, plant_name, plant_stage = 0):
	var plant_name_lower = plant_name.to_lower()
	# Add scene instance to plant store node
	var plant_scene = plants[plant_names.find(plant_name_lower)]
	var object = plant_scene.instance()
	object.position = map_to_world(cellpos)
	object.grid_position = cellpos
	object.stage_index = plant_stage
	plant_store.add_child(object)
	
#	object.plant(GameWorld.current_tool, 2)
	
	# Add tile to tile map
	set_cell(cellpos.x, cellpos.y, plant_names.find(plant_name_lower))
	
	return object

func get_plant(cellpos):
	for plant in plant_store.get_children():
		if(plant.grid_position == cellpos):
			return plant

func is_plant_on_position(cellpos):
	if(get_cellv(cellpos) == -1):
		return false
	else:
		return true

func remove_plant(cellpos):
	# remove plant instance
	get_plant(cellpos).queue_free()
	
	# delete tile
	set_cellv(cellpos, -1)

func handleHarvest(cellpos):
	# check if there is a plant
	if(!is_plant_on_position(cellpos)):
		return
	
	var plant = get_plant(cellpos)
	
	# check if plant is fully grown
	if(!plant.is_max_stage()):
		return
	
	# check if plant is a weed
	if(plant.harvest_count_min <= 0):
		# Unset current particle texture
		harvest_particles.texture = null
		# Emit particles
		GameWorld.paticles.emit_particle_on_mouse(harvest_particles)
		
		remove_plant(cellpos)
		return
	
	# Harvest plant
	plant.harvest()
	GameWorld.Audio.play_sfx_random_pitch('ScissorsOpenClose')
	
	# Check plant harvest stage
	if(plant.harvest_stage_index < 0):
		# Remove plant
		remove_plant(cellpos)
	else:
		# Reset plant to harvest stage
		plant.set_stage(plant.harvest_stage_index)
	
	# Change ground to dirt
	GameWorld.change_ground(cellpos, "soil")
