extends Node2D

export(String) var plant_name
export(Texture) var icon_fruit_texture
export(Texture) var dead_texture
export(Texture) var harvest_particle_texture
export(Array, int) var stages_day = []
export(Array, Texture) var stages_texture = []
export(int) var harvest_count = 1
export(int) var harvest_stage_index = -1
export(int) var base_sell_price = 1

var age = 0
var stage_index = 0
var grid_position = Vector2(0, 0)

var Item = preload("res://scenes/Item.tscn")

onready var harvest_particles = get_node("HarvestParticles")
onready var GameWorld = get_node("/root/GameWorld")


func _ready():
	GameWorld.connect("new_day", self, "_on_new_day")
	
	# Make sure that age = stage
	age = stages_day[stage_index]
	
	$CurrentStageTexture.texture =  stages_texture[stage_index]
	
	# Set Harvest Particle Texture
	harvest_particles.texture = harvest_particle_texture

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

func harvest():
	# Emmit harvest particles
	harvest_particles.restart()

	# check plants harvest count
	if(harvest_count <= 0):
		remove()
		return
	
	# Create new Item
	var new_item = Item.instance()
	new_item.create_fruid_item(plant_name, icon_fruit_texture, harvest_count, base_sell_price)
	# Add fruit to shack
	GameWorld.Shack.add_item(new_item)
	
	# Check plant harvest stage
	if(harvest_stage_index < 0):
		# Remove plant
		remove()
	else:
		# Reset plant to harvest stage
		set_stage(harvest_stage_index)
	
	

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
