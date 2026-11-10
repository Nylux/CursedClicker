class_name OperationData extends RefCounted

var who: int
var op: GameData.Operation
var target: int

# x = from, y = to, z = op
func _init(p_key: Vector3i) -> void:
    who = p_key.x
    target = p_key.y
    op = p_key.z as GameData.Operation


func _to_string() -> String:
    return "%s: %s in %s" % [who, GameData.Operation.keys()[op], target]