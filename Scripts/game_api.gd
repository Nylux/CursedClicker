class_name GameApi extends RefCounted


static func unlock_next_node(gs: GameState) -> void:
	gs.features.unlock(gs.features.get_next_unlock())

static func unlock_node(gs: GameState, node: UnlockableNode) -> void:
	gs.features.unlock(node)

static func _on_node_unlocked(node: UnlockableNode) -> void:
	print("%s is unlocked" % node)

static func reset_game(gs: GameState) -> void:
	gs.reset()
