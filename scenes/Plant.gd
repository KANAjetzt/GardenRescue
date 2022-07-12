extends Node2D

export(Texture) var dead_texture
export(Array, int) var stages_day = []
export(Array, Texture) var stages_texture = []

var age = 0
var stage_index = 0
var grid_position = Vector2(0, 0)

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	GameWorld.connect("new_day", self, "_on_new_day")
	
	$CurrentStageTexture.texture =  stages_texture[stage_index]

func _on_new_day(day):
	# Plant gets older
	age += 1
	
	# Check if max stage
	if(stage_index + 1 == stages_day.size()):
		return
	
	# Check if there is a new stage reached
	for day in stages_day:
		if(day == age):
			# update stage
			stage_index = stages_day.find(day)
			# update texture
			$CurrentStageTexture.texture = stages_texture[stage_index]
