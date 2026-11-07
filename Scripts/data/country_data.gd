class_name CountryData extends RefCounted

enum DiplomaticStatus {
    NO_RELATION,
    OPEN_WAR,
    COLD_WAR,
    ECONOMIC_RELATION,
    SHARED_INTEREST,
    SUBJUGATED,
}

var name: String
var diplomatic_status: DiplomaticStatus
var res: float

func _init(p_name: String) -> void:
    name = p_name
    diplomatic_status = DiplomaticStatus.NO_RELATION
    res = 0.0
