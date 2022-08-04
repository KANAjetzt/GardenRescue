extends Node

onready var GameWorld = get_node("/root/GameWorld")
onready var cross_fade = $CrossFade
onready var ambient_day = $AudioAmbientDay
onready var ambient_night = $AudioAmbientNight
onready var sound_track = $AudioSoundTrack

func _ready():
	GameWorld.connect("sunrise", self, "_on_sunrise")
	GameWorld.connect("sunset", self, "_on_sunset")
	GameWorld.connect("new_day", self, "_on_new_day")
	ambient_night.play()

func crossfade():
	if(ambient_day.playing && ambient_night.playing):
		return
	
	if(ambient_day.playing):
		ambient_night.play()
		cross_fade.play("FadeToNight")
	else:
		ambient_day.play()
		cross_fade.play("FadeToDay")

func _on_sunrise():
	crossfade()
	
func _on_sunset():
	crossfade()
	
func _on_new_day(day):
	var random = rand_range(0.0, 1.0)
	if(random > 0.75 && !sound_track.playing):
		sound_track.play()
