extends Node2D

export(Texture) var seed_texture
export(Texture) var seedling_texture
export(Texture) var sprouting_texture
export(Texture) var fruit_texture
export(Texture) var dead_texture
export(String, "Store", "Shack") var location = "Store"
export(Dictionary) var stages = {
	"seed": 1,
	"seedling": 4,
	"sprouting": 5,
	"fruit": 6,
}
export(String, "seed", "seedling", "sprouting", "fruit") var current_stage = "seed"

var stages_with_texture = null
var age = 0


onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	GameWorld.connect("new_day", self, "_on_new_day")
		
	stages_with_texture = {
	"seed": {
		"days": stages.seed,
		"texture": seed_texture
	},
	"seedling": {
		"days": stages.seedling,
		"texture": seedling_texture
	},
	"sprouting": {
		"days": stages.sprouting,
		"texture": sprouting_texture
	},
	"fruit": {
		"days": stages.fruit,
		"texture": fruit_texture
	},
}

func _on_new_day(day):
	# Plant gets older
	age += 1
	
	# Check if max stage
	if(age > stages.fruit):
		return
	
	# Check if there is a new stage reached
	for stage_key in stages.keys():
		var stage = stages[stage_key]
		if(stage == age):
			# update stage
			current_stage = stage
			# update texture
			$CurrentStageTexture.texture = stages_with_texture[stage_key].texture
