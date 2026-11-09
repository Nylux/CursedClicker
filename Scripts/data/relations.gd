class_name Relations extends RefCounted

var _data: Dictionary[Vector2i, RelationData] = {}

static func _key(a: int, b: int) -> Vector2i:
    return Vector2i(mini(a, b), maxi(a, b))


func get_relation(a: int, b: int) -> RelationData:
    var k: Vector2i = _key(a, b)
    if not _data.has(k):
        _data[k] = RelationData.new()

    return _data[k]


func set_relation(a: int, b: int, r: RelationData) -> void:
    var k: Vector2i = _key(a, b)
    _data[k] = r
