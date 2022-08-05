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
var font_label = preload("res://assets/fonts/Edu_NSW_ACT_Foundation/static/Edu_16_bold.tres")

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

func harvest():
	var harvest_count = get_harvest_count()
	var label_harvest_count = Label.new()
	var harvest_particles = GameWorld.paticles.get_particle("Harvest")
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
	GameWorld.paticles.emit_particle_on_mouse(harvest_particles)
#	GameWorld.paticles.emit_particle(harvest_particles, start, end, count)
	
	# Show label with harvest count
	label_harvest_count.text = str("+", harvest_count)
	label_harvest_count.rect_position = Vector2(10, 0)
	label_harvest_count.add_font_override('font', font_label)
	add_child(label_harvest_count)
	var tween = create_tween()
	tween.tween_property(label_harvest_count, "rect_position", Vector2(10, -20), 0.2)
	tween.tween_property(label_harvest_count, "self_modulate", Color(1,1,1,1), 0.2)
	tween.tween_property(label_harvest_count, "self_modulate", Color(1,1,1,0), 0.2)
	tween.tween_callback(label_harvest_count, "queue_free")
	
	# Create new Item
	var new_item = Item.instance()
	new_item.create_fruid_item(plant_name, icon_fruit_texture, harvest_count, base_sell_price)
	# Add fruit to shack
	GameWorld.Shack.add_item(new_item)

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
