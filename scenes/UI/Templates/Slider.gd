extends HBoxContainer

signal value_changed(new_value)

export(String) var value setget set_value
export(String) var label_text 
export(String) var spin_box_suffix = "%"
export(int, 0, 100) var spin_box_min_value = 0
export(int, 0, 100) var spin_box_max_value = 100

onready var label = $VBoxContainer/Label
onready var spin_box = $VBoxContainer/HBoxContainer/SpinBox
onready var h_slider = $VBoxContainer/HBoxContainer/HSlider

func _ready():
	label.text = label_text
	spin_box.suffix = spin_box_suffix
	spin_box.min_value = spin_box_min_value
	spin_box.max_value = spin_box_max_value

func set_value(new_value):
	value = new_value
	spin_box.value = new_value
	h_slider.value = new_value
	emit_signal("value_changed", new_value)

func _on_HSlider_value_changed(new_value):
	# Bind the HSlider percentage to the SpinBox
	spin_box.value = new_value
	emit_signal("value_changed", new_value)


func _on_SpinBox_value_changed(new_value):
	# Bind the SpinBox value to the HSlider
	h_slider.value = new_value
	emit_signal("value_changed", new_value)
