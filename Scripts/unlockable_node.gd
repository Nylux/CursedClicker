extends Resource

class_name UnlockableNode

signal node_unlocked

var dependencies: Array[String] = []
var is_unlocked: bool = false

func unlocked() -> void:
	is_unlocked = true
	node_unlocked.emit()
