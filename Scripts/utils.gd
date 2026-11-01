class_name _Utils extends Node


func get_component(parent: Node, component_name: String) -> Node:
	var node: Node = parent.find_child(component_name, true, false)
	if not node:
		push_error("%s not found in scene tree" % component_name)
	return node
