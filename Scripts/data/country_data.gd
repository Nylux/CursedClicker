class_name CountryData extends RefCounted

var name: String
var diplomatic_status: GameData.DiplomaticStatus
var stance: GameData.Stance
var suspicion: int
var treasury: int
var armies: int

func _init(p_name: String) -> void:
    name = p_name
    stance = GameData.Stance.Neutral
    suspicion = 0
    # TODO: this is test values
    treasury = 1_000
    armies = 1_000
    # later:
    # long_term_goal = 
