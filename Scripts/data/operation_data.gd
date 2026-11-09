class_name OperationData extends RefCounted

var who: int
var op: GameData.Operation
var target: int

func _init(p_who: int, p_op: GameData.Operation, p_target: int) -> void:
    who = p_who
    op = p_op
    target = p_target

func _to_string() -> String:
    return "%s: %s in %s" % [who, GameData.Operation.keys()[op], target]