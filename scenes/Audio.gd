extends Node

onready var GameWorld = get_node("/root/GameWorld")
onready var cross_fade = $CrossFade
onready var ambient_day = $AudioAmbientDay
onready var ambient_night = $AudioAmbientNight
onready var sound_track = $AudioSoundTrack
onready var sfx = $SFX


func _ready():
	GameWorld.Audio = self
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

func get_sfx(sfx_name):
	var sfx_collection = null
	
	for i in sfx.get_children():
		if(i.name == sfx_name):
			sfx_collection = i
	
	var sfxs = sfx_collection.get_children()
	var random = randi() % sfxs.size()
	
	return sfxs[random]

func play_sfx(sfx_name):
	get_sfx(sfx_name).play()

func play_sfx_random_pitch(sfx_name, pitch_range = Vector2(0.9, 1.1)):
	var current_sfx = get_sfx(sfx_name)
	var pitch = rand_range(pitch_range.x, pitch_range.y)
	current_sfx.pitch_scale = pitch
	current_sfx.play()
	

func _on_sunrise():
	crossfade()
	
func _on_sunset():
	crossfade()
	
func _on_new_day(day):
	var random = rand_range(0.0, 1.0)
	if(random > 0.75 && !sound_track.playing):
		sound_track.play()
