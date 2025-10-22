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

# step 2: add them in the Array of nodes
var nodes: Array[UnlockableNode] = [
	# core feature
	rituals,
	altar,
	
	# subfeatures
	rituals_stat,
	rituals_stat_power,

	# upgrades
	rituals_improve_click1,
	rituals_improve_click2,
	rituals_improve_click3,
	rituals_improve_click4,
	rituals_improve_click5,
]

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
