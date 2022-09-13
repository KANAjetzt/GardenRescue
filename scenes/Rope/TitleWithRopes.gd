extends Node2D

var Rope = preload("res://scenes/Rope/Rope.tscn")

var start_pos = Vector2.ZERO
var end_pos = Vector2.ZERO

onready var rope_start_l = $RopeStartL
onready var rope_start_r = $RopeStartR
onready var jl = $TitleBoard/JL
onready var jr = $TitleBoard/JR


func _input(event):
	if event is InputEventMouseButton and !event.is_pressed():
		if start_pos == Vector2.ZERO:
			start_pos = get_global_mouse_position()
		elif end_pos == Vector2.ZERO:
			end_pos = get_global_mouse_position()
			var rope = Rope.instance()
			add_child(rope)
			rope.spawn_rope(start_pos, end_pos)
			start_pos = Vector2.ZERO
			end_pos = Vector2.ZERO

func _ready():
	var rope_l = Rope.instance()
	var rope_r = Rope.instance()
	
	# Connect the joins to the last RopePiece
	add_child(rope_l)
	rope_l.rope_end_joint = jl
	rope_l.spawn_rope(rope_start_l.global_position, jl.global_position)
	
	add_child(rope_r)
	rope_r.rope_end_joint = jr
	rope_r.spawn_rope(rope_start_r.global_position, jr.global_position)
	
