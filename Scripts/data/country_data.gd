class_name CountryData extends RefCounted

var name: String
var diplomatic_status: GameData.DiplomaticStatus
var res: float

func _init(p_name: String) -> void:
    name = p_name
    diplomatic_status = GameData.DiplomaticStatus.NO_RELATION
    res = 0.0
