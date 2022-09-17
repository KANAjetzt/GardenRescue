extends Node2D

export(String) var plant_name
export(Texture) var icon_fruit_texture
export(Texture) var dead_texture
export(Texture) var harvest_particle_texture
export(Array, int) var stages_day = []
export(Array, Texture) var stages_texture = []
export(int) var harvest_count_min = 1
export(int) var harvest_count_max = 1
export(int) var harvest_stage_index = -1
export(int) var base_sell_price = 1

var age = 0
var stage_index = 0
var grid_position = Vector2(0, 0)

var Item = preload("res://scenes/Item.tscn")

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	GameWorld.connect("new_day", self, "_on_new_day")
	
	# Make sure that age = stage
	age = stages_day[stage_index]
	
	$CurrentStageTexture.texture =  stages_texture[stage_index]

func is_max_stage():
	if(stage_index + 1 == stages_day.size()):
		return true
	else:
		return false
	
func set_stage(index):
	# update stage
	stage_index = index
	# set age
	age = stages_day[stage_index]
	# update texture
	$CurrentStageTexture.texture = stages_texture[stage_index]

func remove():
	queue_free()
	
func get_harvest_count():
	return floor(rand_range(harvest_count_min, harvest_count_max))

func plant(seed_item):
	var seed_count_shack_invetory = GameWorld.Shack.inventory.get_amount(seed_item.unique_id)
	var seed_count = seed_count_shack_invetory - seed_item.amount_needed
	
	# Check if enough seeds left
	if(seed_count <= 0):
		# Remove current_tool
		GameWorld.unequip_toll()
		# Remove seed item from shack
		GameWorld.Shack.remove_item(seed_item)
		return
	
	# Update seed count
	GameWorld.Shack.inventory.update_amount(seed_item.unique_id, seed_count)

func harvest():
	var harvest_count = get_harvest_count()
	
	GameWorld.UI.show_harvest_count(global_position, harvest_count)
	var harvest_particles = GameWorld.Paticles.get_particle("Harvest")
	harvest_particles.amount = harvest_count
	var direction = global_position.direction_to(GameWorld.Shack.global_position)
	var distance = global_position.distance_to(GameWorld.Shack.global_position)
	harvest_particles.process_material.direction = Vector3(direction.x, direction.y, 0)
	# I guess there is a nice way to calculate the travel time of the particles
	# But this is working for now '^^
	harvest_particles.lifetime = distance * 0.002

	# Set harvest particle texture
	harvest_particles.texture = harvest_particle_texture
	
	# Emit particles
	GameWorld.Paticles.emit_particle_on_mouse(harvest_particles)
	
	
	
	
	# Add fruit to shack
	var item = ItemDatabase.get_item_data(str("fruid_", plant_name))
	GameWorld.Shack.inventory.add_item(item.unique_id, harvest_count)

func _on_new_day(day):
	# Plant gets older
	age += 1
	
	# Check if max stage
	if(is_max_stage()):
		return
	
	# Check if there is a new stage reached
	for day in stages_day:
		if(day == age):
			# update stage
			stage_index = stages_day.find(day)
			# update texture
			$CurrentStageTexture.texture = stages_texture[stage_index]