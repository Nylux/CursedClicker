class_name RelationData extends RefCounted

var status: GameData.DiplomaticStatus
var suspicion: int

func _init() -> void:
    status = GameData.DiplomaticStatus.NO_RELATION
    suspicion = 0
