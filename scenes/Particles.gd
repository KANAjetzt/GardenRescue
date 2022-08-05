extends Node2D

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	GameWorld.paticles = self

func get_particle(name):
	for particle in get_children():
		if(particle.name == name):
			return particle
			
func emit_particle_on_mouse(particle):
	# Set particle position to mouse position
	particle.position = get_global_mouse_position()
	
	# Start emmitting
	particle.restart()

func emit_particle(particle, start, end, count):
	pass
