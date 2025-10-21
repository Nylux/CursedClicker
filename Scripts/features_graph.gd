extends Node

var features := UnlockableGraph.new()
var rituals := UnlockableNode.new("rituals")
var cotton := UnlockableNode.new("cotton", ["rituals"])
var academy := UnlockableNode.new("academy", ["rituals", "cotton"])

func _init() -> void:
	features.add(rituals)
	features.add(cotton)
	features.add(academy)

	print(features.get_next_unlock())
	print(features.is_unlockable(rituals))
	features.unlock(rituals)
	print(features.get_next_unlock())
