extends TileMap

var material_border = preload("res://shader/Border.tres")

var hovered_cell = null
var current_cell = null

func _unhandled_input(event):
	if event is InputEventMouseMotion:
			var global_mouse_position = get_global_mouse_position()
			var cell_position = world_to_map(to_local(global_mouse_position))			
			var cell_id = get_cellv(cell_position)
			
			current_cell = cell_position
			
			if(!hovered_cell):
				set_hover(cell_position)
			if(hovered_cell != current_cell):
				unset_hover()

func _ready():
	tile_set.tile_set_material(0, material_border)

func set_hover(cell_position):
	set_cell(cell_position.x, cell_position.y, 0)
	hovered_cell = cell_position
	
func unset_hover():
	set_cellv(hovered_cell, -1)
	hovered_cell = null
