extends Node

onready var GameWord = get_node("/root/GameWorld")

func _ready():
	# Add Tools to GameWord
	var tools = get_children()
	print("get_children: ", tools)
	
	for i in tools:
		if(i.location == 'Shack'):
			GameWord.tools_shack.append(i)
		elif(i.location == 'Store'):
			GameWord.tools_store.append(i)
	
	
