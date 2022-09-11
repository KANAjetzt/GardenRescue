extends Popup

signal save_requested

onready var settings = $Settings


func _on_Continue_pressed():
	hide()


func _on_Settings_pressed():
	settings.show()


func _on_Exit_pressed():
	get_tree().quit()


func _on_Save_pressed():
	emit_signal("save_requested")
