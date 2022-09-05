# Stores items' metadata. This kind of metadata will change during development (renaming items, giving them new sprites...)
# so you should never save it in the save game. Instead, you should always work with unique ids that will never change.
class_name ItemData
extends Resource

# We use this unique id to retrieve an item's data and, for example, display it in the inventory.
# See ItemDatabase.gd and Inventory.gd to see how we use this.
export(String) var unique_id
export(String) var display_name
export(String) var plant
export(String) var description
export(Texture) var icon
export(String, 'tool', 'seed', 'fruit') var type
export(bool) var is_stackable = false
export(bool) var is_one_time_purchase = false
export(bool) var is_shack_sell_possible = false
export(int, 1000) var amount
export(int, 1000) var amount_needed
export(int) var price
