extends RefCounted

class_name UnlockableNode

signal node_unlocked

var node_name: String
var dependencies: Array[String]

func _init(name: String, dep: Array[String] = []) -> void:
	node_name = name
	dependencies = dep

func unlocked() -> void:
	node_unlocked.emit()
