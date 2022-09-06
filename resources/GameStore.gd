class_name GameStore
extends Resource

signal store_changed(prop)

var time = 0
var current_time = 0
var time_multiplier = 3
var day_count = 0
var money = 1500
var current_tool = null

func set_prop(prop, value):
	self[prop] = value
	emit_changed()
	emit_signal("store_changed", prop)
	return self[prop]
