extends Node

var features := UnlockableGraph.new()

# step 1: declare your nodes

## core features
var rituals := UnlockableNode.new("rituals")
var altar := UnlockableNode.new("altar", [rituals])

## subfeatures
var rituals_stat := UnlockableNode.new("rituals_stat", [rituals])
var rituals_stat_power := UnlockableNode.new("rituals_stat_power", [rituals_stat])

## upgrades
var rituals_improve_click1 := UnlockableNode.new("rituals_improve_click1", [rituals_stat_power])
var rituals_improve_click2 := UnlockableNode.new("rituals_improve_click2", [rituals_improve_click1])
var rituals_improve_click3 := UnlockableNode.new("rituals_improve_click3", [rituals_improve_click2])
var rituals_improve_click4 := UnlockableNode.new("rituals_improve_click4", [rituals_improve_click3])
var rituals_improve_click5 := UnlockableNode.new("rituals_improve_click5", [rituals_improve_click4])

# step 2: add a progression value
enum PROGRESSION {
	RITUALS,
	ALTAR,
	
	RITUALS_STAT,
	RITUALS_STAT_POWER,
	
	RITUALS_CLICK_POWER
}

# step 3: add them in the Dictionary of nodes
var nodes: Dictionary[UnlockableNode, PROGRESSION] = {
	# core feature
	rituals: PROGRESSION.RITUALS,
	altar: PROGRESSION.ALTAR,
	
	# subfeatures
	rituals_stat: PROGRESSION.RITUALS_STAT,
	rituals_stat_power: PROGRESSION.RITUALS_STAT_POWER,
	
	# upgrades
	rituals_improve_click1: PROGRESSION.RITUALS_CLICK_POWER,
	rituals_improve_click2: PROGRESSION.RITUALS_CLICK_POWER,
	rituals_improve_click3: PROGRESSION.RITUALS_CLICK_POWER,
	rituals_improve_click4: PROGRESSION.RITUALS_CLICK_POWER,
	rituals_improve_click5: PROGRESSION.RITUALS_CLICK_POWER,
}

func _init() -> void:
	for n: UnlockableNode in nodes:
		n.connect_unlocked(_on_node_unlocked.bind(n))
		features.add(n)

func unlock_next_node() -> void:
	features.unlock(features.get_next_unlock())

func unlock_node(node: UnlockableNode) -> void:
	features.unlock(node)

func _on_node_unlocked(node: UnlockableNode) -> void:
	print("%s is unlocked" % node)
