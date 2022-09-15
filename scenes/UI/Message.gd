extends AcceptDialog

export(String) var message_title setget set_message_title
export(String) var message_text setget set_message_text

func _ready():
	pass

func update_and_show(new_message_title, new_message_text):
	message_title = new_message_title
	message_text = new_message_text
	show()

func set_message_title(new_value):
	message_title = new_value
	window_title = new_value

func set_message_text(new_value):
	message_text = new_value
	dialog_text = new_value
