extends Label

onready var animation_player = $AnimationPlayer

func _ready():
	hide()

func show_message(message):
	show()
	text = message
	animation_player.play("Down")


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Down"):
		yield(get_tree().create_timer(0.8), "timeout")
		animation_player.play("Up")
	else:
		hide()
