extends Control

onready var btn_load = $VBoxContainer/Load
onready var settings = $Settings


func _ready():
	btn_load.grab_focus()

func _on_Load_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_Start_pressed():
	# delete save file first
	var dir = Directory.new()
	# I should definitely make the save file path accessable from the main menu and the saveGameAsJSON Script
	dir.remove("user://save.json")
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_Exit_pressed():
	# I should add a modal to check if the user really wants to leave
	get_tree().quit()


func _on_Settings_pressed():
	settings.show_settings()
