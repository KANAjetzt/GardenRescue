extends Node2D

export(float, 0.0, 50.0) var texture_scale = 0.15
onready var animation_player = $AnimationPlayer
onready var timer_walk_by = $TimerWalkBy

onready var GameWorld = get_node("/root/GameWorld")

# Called when the node enters the scene tree for the first time.
func _ready():
	GameWorld.connect("sunrise", self, "_on_sunrise")
	GameWorld.connect("sunset", self, "_on_sunset")

func start_timer_random():
	timer_walk_by.wait_time = randi() % 8 + 1
	timer_walk_by.start()


func _on_sunrise():
	# Play light sutting of animation
	animation_player.play("Off")

func _on_sunset():
	# Play light turning on animation
	animation_player.play("On")
	start_timer_random()
	
func _on_TimerWalkBy_timeout():
	animation_player.play("walkBy")
	if(!GameWorld.is_day):
		start_timer_random()
