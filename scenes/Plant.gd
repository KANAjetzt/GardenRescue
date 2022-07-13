extends Node2D

export(Texture) var icon_fruit_texture
export(Texture) var dead_texture
export(Array, int) var stages_day = []
export(Array, Texture) var stages_texture = []
export(int) var harvest_count = 1
export(int) var base_sell_price = 1

var age = 0
var stage_index = 0
var grid_position = Vector2(0, 0)

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
