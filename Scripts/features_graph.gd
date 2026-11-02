# storage of all unlockable nodes and graph describing how the game progresses
extends Node

var features := UnlockableGraph.new()

# step 1: declare your nodes

## core features
var rituals := UnlockableNode.new("rituals")
var altar := UnlockableNode.new("altar", [rituals])
var expedition := UnlockableNode.new("expedition", [altar])
var temple := UnlockableNode.new("temple", [expedition])
var infiltration := UnlockableNode.new("infiltration", [temple])

## subfeatures
var rituals_stat := UnlockableNode.new("rituals_stat", [rituals])
var rituals_stat_power := UnlockableNode.new("rituals_stat_power", [rituals_stat])

var altar_curse1 := UnlockableNode.new("altar_curse1", [altar])
var altar_curse2 := UnlockableNode.new("altar_curse2", [altar])
var altar_curse3 := UnlockableNode.new("altar_curse3", [altar])

var expedition_stat_loss_rate := UnlockableNode.new("expedition_stat_loss_rate", [expedition])
var expedition_stat_success_rate := UnlockableNode.new("expedition_stat_success_rate", [expedition_stat_loss_rate])
var expedition_stat_loot := UnlockableNode.new("expedition_stat_loot", [expedition_stat_success_rate])

var temple_slot_1 := UnlockableNode.new("temple_slot_1", [temple])
var temple_slot_2 := UnlockableNode.new("temple_slot_2", [temple_slot_1])


## upgrades
var rituals_improve_click1 := UnlockableNode.new("rituals_improve_click1", [rituals_stat_power])
var rituals_improve_click2 := UnlockableNode.new("rituals_improve_click2", [rituals_improve_click1])
var rituals_improve_click3 := UnlockableNode.new("rituals_improve_click3", [rituals_improve_click2])
var rituals_improve_click4 := UnlockableNode.new("rituals_improve_click4", [rituals_improve_click3])
var rituals_improve_click5 := UnlockableNode.new("rituals_improve_click5", [rituals_improve_click4])
var altar_lower_blood_cost1 := UnlockableNode.new("altar_lower_blood_cost1", [altar])
var altar_lower_blood_cost2 := UnlockableNode.new("altar_lower_blood_cost2", [altar_lower_blood_cost1])
var altar_lower_cultist_cost1 := UnlockableNode.new("altar_lower_cultist_cost1", [altar])
var altar_lower_cultist_cost2 := UnlockableNode.new("altar_lower_cultist_cost2", [altar_lower_cultist_cost1])
var altar_improve_zealot_rate1 := UnlockableNode.new("altar_improve_zealot_rate1", [altar])
var altar_improve_zealot_rate2 := UnlockableNode.new("altar_improve_zealot_rate2", [altar_improve_zealot_rate1])
var expedition_lower_cooldown1 := UnlockableNode.new("expedition_lower_cooldown1", [expedition])
var expedition_lower_cooldown2 := UnlockableNode.new("expedition_lower_cooldown2", [expedition_lower_cooldown1])
var expedition_lower_cooldown3 := UnlockableNode.new("expedition_lower_cooldown3", [expedition_lower_cooldown2])
var temple_lower_rate1 := UnlockableNode.new("temple_lower_rate1", [temple])
var temple_lower_rate2 := UnlockableNode.new("temple_lower_rate2", [temple_lower_rate1])
var temple_power1 := UnlockableNode.new("temple_power1", [temple])
var temple_power2 := UnlockableNode.new("temple_power2", [temple_power1])
var temple_power3 := UnlockableNode.new("temple_power3", [temple_power2])
var infiltration_conversion_time := UnlockableNode.new("infiltration_conversion_time", [infiltration])
var infiltration_lower_cost1 := UnlockableNode.new("infiltration_lower_cost1", [infiltration])
var infiltration_lower_cost2 := UnlockableNode.new("infiltration_lower_cost2", [infiltration_lower_cost1])


var nodes: Array[UnlockableNode] = [
	rituals,
	altar,
	expedition,
	temple,
	infiltration,
	rituals_stat,
	rituals_stat_power,
	altar_curse1,
	altar_curse2,
	altar_curse3,
	expedition_stat_loss_rate,
	expedition_stat_success_rate,
	expedition_stat_loot,
	temple_slot_1,
	temple_slot_2,
	rituals_improve_click1,
	rituals_improve_click2,
	rituals_improve_click3,
	rituals_improve_click4,
	rituals_improve_click5,
	altar_lower_blood_cost1,
	altar_lower_blood_cost2,
	altar_lower_cultist_cost1,
	altar_lower_cultist_cost2,
	altar_improve_zealot_rate1,
	altar_improve_zealot_rate2,
	expedition_lower_cooldown1,
	expedition_lower_cooldown2,
	expedition_lower_cooldown3,
	temple_lower_rate1,
	temple_lower_rate2,
	temple_power1,
	temple_power2,
	temple_power3,
	infiltration_conversion_time,
	infiltration_lower_cost1,
	infiltration_lower_cost2,
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
