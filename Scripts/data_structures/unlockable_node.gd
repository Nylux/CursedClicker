extends RefCounted

class_name UnlockableNode

signal node_unlocked

var node_name: String
var dependencies: Array[UnlockableNode]

func _init(name: String, dep: Array[UnlockableNode] = []) -> void:
	node_name = name
	dependencies = dep

func connect_unlocked(c: Callable) -> void:
	if node_unlocked.is_connected(c):
		node_unlocked.disconnect(c)
	node_unlocked.connect(c)

func unlocked() -> void:
	node_unlocked.emit()

func _to_string():
	return "Node(%s)" % node_name
