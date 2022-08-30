extends Node

export(String) var item_name
export(Texture) var icon
export(String, 'tool', 'seed', 'fruit') var type
export(NodePath) var item_reference
export(bool) var is_stackable = false
export(bool) var is_one_time_purchase = false
export(int, 1000) var amount
export(int, 1000) var amount_needed
export(int) var price

func copy_item(item):
	item_name = item.item_name
	icon = item.icon
	type = item.type
	item_reference = item.item_reference
	is_stackable = item.is_stackable
	is_one_time_purchase = item.is_one_time_purchase
	amount = item.amount
	amount_needed = item.amount_needed
	price = item.price

func create_fruid_item(new_item_name, new_icon, new_amount, new_price, new_is_stackable = true):
	item_name = new_item_name
	icon = new_icon
	type = 'fruit'
	amount = new_amount
	price = new_price
	is_stackable = new_is_stackable
	is_one_time_purchase = false
