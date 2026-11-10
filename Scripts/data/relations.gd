class_name Relations extends RefCounted

var _data: Dictionary[Vector2i, RelationData] = {}


func get_relation(from: int, to: int) -> RelationData:
    assert(from != to)
    var k: Vector2i = Vector2i(from, to)
    if not _data.has(k):
        _data[k] = RelationData.new()

    return _data[k]


func set_relation(from: int, to: int, r: RelationData) -> void:
    assert(from != to)
    var k: Vector2i = Vector2i(from, to)
    _data[k] = r
