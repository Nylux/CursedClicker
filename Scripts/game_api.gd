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


static func set_weight(weights: Dictionary[Vector3i, float], from: int, to: int, op: GameData.Operation, weight: float) -> void:
	weights[Vector3i(from, to, op)] = weight


static func init_weight(weights: Dictionary[Vector3i, float], from: int, to: int, op: GameData.Operation) -> void:
	set_weight(weights, from, to, op, 0.)


static func decay_weight(weights: Dictionary[Vector3i, float], from: int, to: int, op: GameData.Operation) -> void:
	var w: float = weights[Vector3i(from, to, op)]
	set_weight(weights, from, to, op, w * AiConfig.DECAY_WEIGHT)


static func add_weight(weights: Dictionary[Vector3i, float], from: int, to: int, op: GameData.Operation, weight: float) -> void:
	var k: Vector3i = Vector3i(from, to, op)
	if not weights.has(k):
		weights[k] = weight
	else:
		weights[k] += weight


static func nth_weight(weights: Dictionary[Vector3i, float], from: int, n: int) -> Array[Vector3i]:
	var from_keys: Array[Vector3i] = weights.keys().filter(func(k: Vector3i): return k.x == from)
	from_keys.sort_custom(func(x: Vector3i, y: Vector3i) -> bool: return weights[x] > weights[y])

	return from_keys.slice(0, n)


static func get_dbg_str(weights: Dictionary[Vector3i, float], from: int) -> String:
	var dbg: String = ""
	for k in GameApi.nth_weight(weights, from, 5):
		dbg += "%s: %s | " % [GameApi.key_to_str(k), weights[k]]
	return dbg


static func key_to_str(k: Vector3i) -> String:
	return "%s: %s in %s" % [k.x, GameData.Operation.keys()[k.z], k.y]


static func is_client_state_of(from: RelationData, to: RelationData) -> bool:
	return from.status == GameData.DiplomaticStatus.CLIENT_STATE and to.status == GameData.DiplomaticStatus.OVERLORD