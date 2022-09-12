extends Popup

onready var volume_sfx = $Background/MarginContainer/VBC/Sliders/VolumeSFX
onready var volume_ambient = $Background/MarginContainer/VBC/Sliders/VolumeAmbient
onready var volume_music = $Background/MarginContainer/VBC/Sliders/VolumeMusic
onready var speed_day = $Background/MarginContainer/VBC/Sliders/SpeedDay

func _ready():
	update_slider_values()
	
func show_settings():
	update_slider_values()
	show()

# map the -30 to 0 audio range to 0 to 100
func map_audio_to_slider(value):
	var t = value * -1 / 30
	var slider_value = lerp(100, 0, t)
	return slider_value

# map the 0 to 100 range to the -30 to 0 range for audio
func map_slider_to_audio(value):
	var t = value / 100
	var audio_value = lerp(-30, 0, t)
	return audio_value

func update_slider_values():
	volume_sfx.value = map_audio_to_slider(GameWorld.gameStore.volume_sfx) 
	volume_ambient.value = map_audio_to_slider(GameWorld.gameStore.volume_ambient)
	volume_music.value = map_audio_to_slider(GameWorld.gameStore.volume_music)
	speed_day.value = GameWorld.gameStore.time_multiplier

func _on_VolumeSFX_value_changed(new_value):
	GameWorld.gameStore.set_prop("volume_sfx", map_slider_to_audio(new_value))
	
func _on_VolumeAmbient_value_changed(new_value):
	GameWorld.gameStore.set_prop("volume_ambient", map_slider_to_audio(new_value))

func _on_VolumeMusic_value_changed(new_value):
	GameWorld.gameStore.set_prop("volume_music", map_slider_to_audio(new_value))
	
func _on_SpeedDay_value_changed(new_value):
	GameWorld.gameStore.time_multiplier = new_value

func _on_Button_pressed():
	hide()
