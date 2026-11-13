class_name CountryData extends RefCounted

var name: String
var stance: GameData.Stance
var treasury: int
var armies: int
var lock_in_operation: int

func _init(p_name: String) -> void:
	name = p_name
	stance = GameData.Stance.NEUTRAL
	# TODO: this is test values
	# between 0, 100 represent power not values
	treasury = 50
	armies = 50
	lock_in_operation = 0
