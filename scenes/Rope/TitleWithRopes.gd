extends Node2D

var Rope = preload("res://scenes/Rope/Rope.tscn")

var start_pos = Vector2.ZERO
var end_pos = Vector2.ZERO

onready var ropes = $Ropes
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
	ropes.add_child(rope_l)
	rope_l.rope_end_joint = jl
	rope_l.get_node("RopeEndPiece").queue_free()
	rope_l.spawn_rope(rope_start_l.position, jl.position)
	
	ropes.add_child(rope_r)
	rope_r.rope_end_joint = jr
	rope_r.get_node("RopeEndPiece").queue_free()
	rope_r.spawn_rope(rope_start_r.position, jr.position)
	
