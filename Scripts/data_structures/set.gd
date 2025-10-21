extends RefCounted

class_name Set

var internal: Dictionary

func _init() -> void:
	internal = {}

func add(item: Variant) -> void:
	internal.set(item, null)

func remove(item: Variant) -> void:
	internal.erase(item)
	
func has(item: Variant) -> bool:
	return internal.has(item)

func size() -> int:
	return internal.size()

func get_all() -> Array:
	return internal.keys()
