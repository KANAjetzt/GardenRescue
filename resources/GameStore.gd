class_name GameStore
extends Resource

signal store_changed(prop)

var time = 0
var current_time = 0
var time_multiplier = 3
var day_count = 0
var money = 20
var current_tool = null
# Turns out it's better to store single values,
# Atleast in the way I build it.
# Because now I only can react to all volumes
# That prevents me from only setting the db values of the one that has changed :(
#var volumes = {
#	"sfx": 0,
#	"ambient": 0,
#	"music": 0,
#}

var volume_sfx = 0
var volume_ambient = 0
var volume_music = 0

# I don't know if this is a great idear, currently I call set_prop from the settings menu
# on slider change - so that get's triggerd quied often, now each and every time the store_changed
# signal is fired and every one who lissens to that starts working ..

func set_prop(prop, value):
	self[prop] = value
	emit_changed()
	emit_signal("store_changed", prop)
	return self[prop]
