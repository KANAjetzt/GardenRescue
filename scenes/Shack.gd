extends "res://scenes/Building.gd"

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	GameWorld.Shack = self

func generate_UI():
	.generate_UI()
