class_name ActionHandler extends RefCounted


static func set_weight(weights: Dictionary[Vector2i, int], c: int, op: GameData.Operation, weight: int) -> void:
	weights[Vector2i(c, op)] = weight


static func init_weight(weights: Dictionary[Vector2i, int], c: int, op: GameData.Operation) -> void:
	set_weight(weights, c, op, 0)


static func add_weight(weights: Dictionary[Vector2i, int], c: int, op: GameData.Operation, weight: int) -> void:
	var k: Vector2i = Vector2i(c, op)
	if not weights.has(k):
		weights[k] = weight
	else:
		weights[k] += weight


static func compute(countries: Dictionary[int, CountryData], relations: Relations, cur_country: int) -> OperationData:

	# init
	# TODO: move weights in game_state so it could be reused to hold memories of passed actions
	var weights: Dictionary[Vector2i, int] = {}
	for c in countries:
		if c == cur_country:
			continue
		for op in GameData.Operation.values():
			init_weight(weights, c, op)
	
	# populate
	for c in countries:
		if c == cur_country:
			continue
		var r = relations.get_relation(c, cur_country)
		if r.suspicion >= 100:
			add_weight(weights, c, GameData.Operation.DeclareWar, 100)
	
	var max_w: int = 0
	var max_k: Vector2i = Vector2i(-1, GameData.Operation.Invest)
	for k in weights:
		if weights[k] > max_w:
			max_w = weights[k]
			max_k = k
	return OperationData.new(cur_country, max_k.y, max_k.x)
