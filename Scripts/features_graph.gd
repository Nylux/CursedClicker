extends Node

var features := UnlockableGraph.new()
var rituals := UnlockableNode.new("rituals")
var cotton := UnlockableNode.new("cotton", [rituals])
var academy := UnlockableNode.new("academy", [rituals, cotton])

func _init() -> void:
	rituals.connect_unlocked(_on_node_unlocked.bind(rituals))
	cotton.connect_unlocked(_on_node_unlocked.bind(cotton))
	academy.connect_unlocked(_on_node_unlocked.bind(academy))
	features.add(rituals)
	features.add(cotton)
	features.add(academy)

func unlock_next_node() -> void:
	features.unlock(features.get_next_unlock())

func _on_node_unlocked(node: UnlockableNode) -> void:
	print("%s is unlocked" % node)
