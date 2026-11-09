class_name RelationData extends RefCounted

var _data: Dictionary[Vector2i, GameData.DiplomaticStatus] = {}

static func _key(a: int, b: int) -> Vector2i:
    return Vector2i(a, b)


func get_status(a: int, b: int) -> GameData.DiplomaticStatus:
    var k: Vector2i = _key(a, b)
    if not _data.has(k):
        _data[k] = GameData.DiplomaticStatus.NO_RELATION

    return _data[k]
