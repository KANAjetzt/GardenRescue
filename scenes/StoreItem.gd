extends Node

export(String) var item_name
export(Texture) var icon
export(String, 'tool', 'seed', 'fruit') var type
export(NodePath) var item_reference
export(int, 1000) var amount
export(int) var price

func copy_item(item):
	item_name = item.item_name
	icon = item.icon
	type = item.type
	item_reference = item.item_reference
	amount = item.amount
	price = item.price

func create_fruid_item(name, icon, amount, price):
	item_name = name
	icon = icon
	type = 'fruit'
	amount = amount
	price = price
