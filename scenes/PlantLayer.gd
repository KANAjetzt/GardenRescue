extends TileMap

onready var GameWorld = get_node("/root/GameWorld")

export(PackedScene) var Item
export(Array, String) var plant_names
export(Array, PackedScene) var plants
export(NodePath) var plant_nodes_path
onready var plant_nodes = get_node(plant_nodes_path)

onready var harvest_particles = GameWorld.Paticles.get_particle("Harvest")

var plant_store = preload("res://resources/stores/PlantStore.tres")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var global_mouse_position = get_global_mouse_position()
			var clicked_cell_position = world_to_map(to_local(global_mouse_position))
			var clicked_cell_id = get_cellv(clicked_cell_position)
			
			print(global_mouse_position, clicked_cell_position, clicked_cell_id)
			
			# if there is no tool selected
			if(!GameWorld.gameStore.current_tool):
				return
			
			# if there is no plant on this position
			if(!is_plant_on_position(clicked_cell_position)):
				return
			
			match GameWorld.get_current_tool().display_name.to_lower():
				'scissors':
					handleHarvest(clicked_cell_position)
				'hand':
					if(plant_store.get_plant(clicked_cell_position).harvest_count <= 0):
						handleHarvest(clicked_cell_position)
				

func _ready():
	hide()
	GameWorld.PlantLayer = self
	
	plant_store.connect("loaded_plants", self, "_plant_restore")
	
	for cellpos in get_used_cells():
		var cell_index = get_cellv(cellpos)
		load_plant(cellpos, cell_index)

func load_plant(cell_pos: Vector2, cell_index: int):
	if (plants[cell_index]):
		# Instance plant at max stage if grass
		if(plant_names[cell_index].to_lower() == "grass"):
			instsance_plant(cell_pos, plant_names[cell_index], 4)
		else:
			instsance_plant(cell_pos, plant_names[cell_index])

func instsance_plant(cellpos: Vector2, plant_name, plant_stage = 0,  plant_age  = 0):
	var plant_name_lower = plant_name.to_lower()
	# Add scene instance to plant store node
	var plant_scene = plants[plant_names.find(plant_name_lower)]
	var object = plant_scene.instance()
	object.position = map_to_world(cellpos)
	object.grid_position = cellpos
	object.age = plant_age
	object.stage_index = plant_stage
	
	# Check if plant age is smaller then it should be
	if(object.age < object.stages_day[object.stage_index]):
		object.age = object.stages_day[object.stage_index]
	
	plant_nodes.add_child(object)
	plant_store.add_plant(object)
	
	# Add tile to tile map
	set_cell(cellpos.x, cellpos.y, plant_names.find(plant_name_lower))
	
	return object

func get_plant(cellpos):
	for plant in plant_nodes.get_children():
		if(plant.grid_position == cellpos):
			return plant

func is_plant_on_position(cellpos):
	if(get_cellv(cellpos) == -1):
		return false
	else:
		return true

func remove_plant(cellpos):
	# remove plant node
	get_plant(cellpos).queue_free()
	# remove plant from store
	plant_store.remove_plant(plant_store.get_plant(cellpos))	
	# delete tile
	set_cellv(cellpos, -1)

func remove_all_plants():
	for cellpos in get_used_cells():
		remove_plant(cellpos)

func handleHarvest(cellpos):
	# check if there is a plant
	if(!is_plant_on_position(cellpos)):
		return
	
	var plant = plant_store.get_plant(cellpos)
	
	# check if plant is fully grown
	if(!plant.is_max_stage()):
		return
	
	# check if plant is a weed
	if(plant.harvest_count_min <= 0):
		# Unset current particle texture
		harvest_particles.texture = null
		# Emit particles
		GameWorld.Paticles.emit_particle_on_mouse(harvest_particles)
		
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

func _plant_restore(save_data):
	remove_all_plants()
	plant_store.clear()
	
	for plant in save_data:
		instsance_plant(
			Vector2(plant.pos.x, plant.pos.y),
			plant.name,
			plant.stage,
			plant.age)
