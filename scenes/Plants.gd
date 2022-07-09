extends Node

onready var GameWord = get_node("/root/GameWorld")

func _ready():
	# Add Tools to GameWord
	var plants = get_children()
	for i in plants:
		if(i.location == 'Shack'):
			GameWord.plants_shack.append(i)
		elif(i.location == 'Store'):
			GameWord.plants_store.append(i)
