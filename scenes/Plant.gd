extends Node2D

export(Texture) var seed_texture
export(Texture) var seedling_texture
export(Texture) var sprouting_texture
export(Texture) var fruit_texture
export(Texture) var dead_texture
export(String, "Store", "Shack") var location = "Store"
export(Dictionary) var stages = {
	"seed": 0,
	"seedling": 1,
	"sprouting": 2,
	"fruit": 3,
}
export(String, "seed", "seedling", "sprouting", "fruit") var current_stage = "seed"

var age = 0
var textures = []
var current_texture_index = 1
var current_texture = null

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	GameWorld.connect("new_day", self, "_on_new_day")
	
	textures = [dead_texture, seed_texture, seedling_texture, sprouting_texture, fruit_texture]
	current_texture = textures[current_texture_index]
	age = stages[current_stage]

func _on_new_day(day):
	# Plant gets older
	age += 1
	
	# Check if max stage
	if(age >= stages.fruit):
		return
	
	# Check if there is a new stage reached
	for stage_key in stages.keys():
		var stage = stages[stage_key]
		if(stage == age):
			# update stage
			current_stage = stage
			# update texture
			current_texture_index += 1
			current_texture = textures[current_texture_index]
			$CurrentStageTexture.texture = current_texture
