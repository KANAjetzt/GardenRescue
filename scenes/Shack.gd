extends "res://scenes/Building.gd"

onready var animated_sprite = $AnimatedSprite


func _ready():
	GameWorld.Shack = self
	print("ready shack: ", items)
	.init_ui()


func sell_item(item):
	# Play sell sound
	GameWorld.Audio.play_sfx_random_pitch("Sell")
	# Emit particles 
	var particles_coin = GameWorld.paticles.get_particle("Coins")
	particles_coin.amount = item.price * item.amount
	GameWorld.paticles.emit_particle_on_mouse(particles_coin)
	# Play money add animation
	
	
	# Add money
	GameWorld.money = GameWorld.money + item.price * item.amount
	# Update money UI
	GameWorld.UI.update_money()
	.remove_item(item)

func _on_Shack_clicked_on_building():
	GameWorld.Audio.play_sfx("DoorOpen")
	animated_sprite.play("default")
	inventory.show()

func _on_Inventory_pressed_slot(item_name):
	var clicked_item = .get_item(item_name)
	
	# Check if itam has price
	if(clicked_item.price > 0):
		sell_item(clicked_item)
		return
	
	GameWorld.Audio.play_sfx("Equip")
	GameWorld.equip_tool(clicked_item)


func _on_Inventory_closed():
	animated_sprite.play("default", true)
