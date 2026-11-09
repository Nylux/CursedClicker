class_name GameApi extends RefCounted


static func unlock_next_node(gs: GameState) -> void:
	gs.features.unlock(gs.features.get_next_unlock())


static func unlock_node(gs: GameState, node: UnlockableNode) -> void:
	gs.features.unlock(node)


static func try_unlock_node(gs: GameState, node: UnlockableNode) -> void:
	if gs.features.is_unlockable(node):
		gs.features.unlock(node)


static func _on_node_unlocked(node: UnlockableNode) -> void:
	print("%s is unlocked" % node)


static func reset_game(gs: GameState) -> void:
	gs.reset()


static func set_weight(weights: Dictionary[Vector3i, int], from: int, to: int, op: GameData.Operation, weight: int) -> void:
	weights[Vector3i(from, to, op)] = weight


static func init_weight(weights: Dictionary[Vector3i, int], from: int, to: int, op: GameData.Operation) -> void:
	set_weight(weights, from, to, op, 0)


static func decay_weight(weights: Dictionary[Vector3i, int], from: int, to: int, op: GameData.Operation) -> void:
	var w: int = weights[Vector3i(from, to, op)]
	set_weight(weights, from, to, op, int(w * .95))


static func add_weight(weights: Dictionary[Vector3i, int], from: int, to: int, op: GameData.Operation, weight: int) -> void:
	var k: Vector3i = Vector3i(from, to, op)
	if not weights.has(k):
		weights[k] = weight
	else:
		weights[k] += weight
