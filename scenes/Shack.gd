extends "res://scenes/Building.gd"

onready var animated_sprite = $AnimatedSprite


func _ready():
	GameWorld.Shack = self
	print("ready shack: ", items)


func sell_item(item):
	var item_amount = inventory.get_amount(item.unique_id)
	
	# Play sell sound
	GameWorld.Audio.play_sfx_random_pitch("Sell")
	# Emit particles 
	var particles_coin = GameWorld.Paticles.get_particle("Coins")
	particles_coin.amount = item.price * item_amount
	GameWorld.Paticles.emit_particle_on_mouse(particles_coin)
	# Play money add animation
	
	
	# Add money
	GameWorld.add_money(item.price * item_amount)
	# Update money UI
	GameWorld.UI.update_money()
	.remove_item(item)

func _on_Shack_clicked_on_building():
	GameWorld.Audio.play_sfx("DoorOpen")
	animated_sprite.play("default")
	ui_inventory.show()

func _on_Inventory_pressed_slot(item_id):
	var clicked_item = ItemDatabase.get_item_data(item_id)
	
	# Check if itam has price
	if(clicked_item.is_shack_sell_possible):
		sell_item(clicked_item)
		return
	
	GameWorld.Audio.play_sfx("Equip")
	GameWorld.equip_tool(clicked_item)


func _on_Inventory_closed():
	animated_sprite.play("default", true)
