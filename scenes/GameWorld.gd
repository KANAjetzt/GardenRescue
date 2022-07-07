extends Node

var tools_shack = []
var tools_store = []
var current_tool = null

signal tool_equiped

func equip_tool(tool_to_equip):
	current_tool = tool_to_equip
	emit_signal("tool_equiped")
	print('eqiped new tool: ', current_tool)
