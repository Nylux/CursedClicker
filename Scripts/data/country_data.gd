class_name CountryData extends RefCounted

var name: String
var stance: GameData.Stance
var treasury: int
var armies: int
var lock_in_operation: int

func _init(p_name: String) -> void:
    name = p_name
    stance = GameData.Stance.Neutral
    # TODO: this is test values
    treasury = 1_000
    armies = 1_000
    lock_in_operation = 0
    # later:
    # long_term_goal = 
