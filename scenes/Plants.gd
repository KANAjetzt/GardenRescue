extends Node

onready var GameWord = get_node("/root/GameWorld")

func _ready():
	# Add Tools to GameWord
	var plants = get_children()
	print(plants)
	for i in plants:
		print(i)
		print(i.location)
		if(i.location == 'Shack'):
			GameWord.plants_shack.append(i)
		elif(i.location == 'Store'):
			GameWord.plants_store.append(i)
	
	print("add Plants to GameWorld: ", GameWord.plants_store)
