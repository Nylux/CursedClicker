class_name ActionHandler extends RefCounted


static func compute(
	countries: Dictionary[int, CountryData], 
	relations: Relations, 
	weights: Dictionary[Vector3i, int], 
	cur_country: int
) -> OperationData:

	# decay
	# TODO: unify the for loops using a function call
	for to in countries:
		if to == cur_country:
			continue
		for op in GameData.Operation.values():
			GameApi.decay_weight(weights, cur_country, to, op)

	# logic
	for to in countries:
		if to == cur_country:
			continue
		var r = relations.get_relation(to, cur_country)
		if r.suspicion >= 100:
			GameApi.add_weight(weights, cur_country, to, GameData.Operation.DeclareWar, 100)
	
	var max_w: int = 0
	# x = from, y = to, z = op
	# TODO: use a custom RefCounted but doing that remove the hash by value so weight will have to be rewritten
	var max_k: Vector3i = Vector3i(cur_country, cur_country, GameData.Operation.Invest)
	for k in weights:
		if weights[k] > max_w:
			max_w = weights[k]
			max_k = k

	return OperationData.new(cur_country, max_k.z, max_k.y)
