extends CanvasLayer

signal save_requested
signal reload_requested

var font_label = preload("res://assets/fonts/Edu_NSW_ACT_Foundation/static/Edu_16_bold.tres")

onready var GameWorld = get_node("/root/GameWorld")

export (NodePath) var ui_current_tool_path
onready var ui_current_tool = get_node(ui_current_tool_path)
export (NodePath) var ui_current_day_path
onready var ui_current_day = get_node(ui_current_day_path)
export (NodePath) var ui_money_path
onready var ui_money = get_node(ui_money_path)
onready var animation_money_added = $TopLeft/MarginContainer/VBC/Money/AnimationMoneyAdded
onready var pause_menu = $PauseMenu
onready var message = $Message
onready var toast_message = $ToastMessage

func _ready():
	pause_menu.connect("save_requested", self, "emit_signal", ["save_requested"])
	
	GameWorld.gameStore.connect("store_changed", self, "_on_store_changed")
	GameWorld.connect("tool_equiped", self, "_on_tool_equiped")
	GameWorld.connect("tool_unequiped", self, "_on_tool_unequiped")
	GameWorld.connect("new_day", self, "_on_new_day")
	ui_money.text = str(GameWorld.get_money())
	ui_current_day.text = str("It's day: ", GameWorld.gameStore.day_count)
	
	GameWorld.UI = self

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if(!pause_menu.visible):
				GameWorld.pause_game()
			else: 
				GameWorld.resume_game()

# Used in GameWord --> Use the GameWorld.pause_game() to pause the game
func show_pause_menu():
	pause_menu.show()

# Used in GameWord --> Use the GameWorld.resume_game() to resume the game
func hide_pause_menu():
	pause_menu.hide()

func show_message_popup(title, text):
	message.message_title = title
	message.message_text = text
	message.show()

func show_toast_message(message):
	toast_message.show_message(message)

# Show label with harvest count
func show_harvest_count(position, harvest_count_number):
	var label = Label.new()
	label.text = str("+", harvest_count_number)
	label.rect_position = position + Vector2(0, -20)
	label.rect_scale = Vector2(2.0, 2.0)
	label.self_modulate =  Color(1,1,1,0)
	label.add_font_override('font', font_label)
	add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "self_modulate", Color(1,1,1,1), 0.15)
	tween.tween_property(label, "rect_position", position + Vector2(0, -40), 0.15)
	tween.tween_property(label, "self_modulate", Color(1,1,1,0), 0.15)
	tween.tween_callback(label, "queue_free")

func _on_new_day(day):
	ui_current_day.text = str("It's day: ", day)

func _on_tool_equiped():
	# Get current tool amount from shack iventory
	var current_tool_data = GameWorld.get_current_tool()
	var amount = GameWorld.Shack.inventory.get_amount(current_tool_data.unique_id)
	
	# Show current tool in UI
	ui_current_tool.update_icon(current_tool_data.icon)
	
	# Check if tool has an amount
	if(amount <= 0):
		ui_current_tool.update_amount(0)
		return
	
	ui_current_tool.update_amount(amount)
	
#	Input.set_custom_mouse_cursor(GameWorld.get_current_tool().icon)

func _on_tool_unequiped():
	ui_current_tool.update_amount(0)
	ui_current_tool.update_icon(null)

func update_money():
	ui_money.text = str(GameWorld.get_money())
	animation_money_added.play("Wave")

func _on_Time_Settings_HSlider_value_changed(value):
	$TimeSettings/Value.text = str(value)
	GameWorld.update_time_multiplier(value)


func _on_GroundLayer_seed_used(seed_item):
	if(!seed_item):
		return
	
	ui_current_tool.update_amount(GameWorld.Shack.inventory.get_amount(seed_item.unique_id))

func _on_store_changed(prop_changed):
	match prop_changed:
		"money":
			update_money()
		"current_tool":
			_on_tool_equiped()
		"day_count":
			_on_new_day(GameWorld.gameStore.day_count)
		_:
			update_money()
			_on_new_day(GameWorld.gameStore.day_count)
			if (GameWorld.get_current_tool()):
				_on_tool_equiped()


func _on_BtnOpenMenu_pressed():
	GameWorld.pause_game()
