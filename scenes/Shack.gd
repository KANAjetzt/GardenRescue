extends Area2D

onready var GameWord = get_node("/root/GameWorld")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(GameWord.tools_shack)
