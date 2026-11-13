class_name RelationData extends RefCounted

var status: GameData.DiplomaticStatus
var hierarchy: GameData.Hierarchy
var suspicion: int
var intel: int

func _init() -> void:
    status = GameData.DiplomaticStatus.NO_RELATION
    hierarchy = GameData.Hierarchy.NONE
    suspicion = 0
    intel = 0