class_name ActionHandler extends RefCounted


static func sig(x: float) -> float:
	return 1.0 / (1.0 + exp(-x))


static func w(x: int, y: int) -> float:
	return sig((x - y) / 100.)


static func compute(
	countries: Dictionary[int, CountryData], 
	relations: Relations, 
	weights: Dictionary[Vector3i, float], 
	cur_country: int
) -> void:

	# decay
	# TODO: unify the for loops using a function call
	for to in countries:
		if to == cur_country:
			continue
		for op in GameData.Operation.values():
			GameApi.decay_weight(weights, cur_country, to, op)

	if countries[cur_country].lock_in_operation > 0:
		return

	# logic
	for to in countries:
		if to == cur_country:
			continue
		var cur_relation = relations.get_relation(cur_country, to)
		var to_relation = relations.get_relation(to, cur_country)
		var w_armies: float = w(countries[cur_country].armies, countries[to].armies)
		var w_treasury: float = w(countries[cur_country].treasury, countries[to].treasury)

		if GameApi.is_client_state_of(to_relation, cur_relation) and w_armies > 0.:
			if cur_relation.status == GameData.DiplomaticStatus.OPEN_WAR:
				GameApi.add_weight(weights, cur_country, to, GameData.Operation.ImposePeace, 100.)
		else:
			if cur_relation.suspicion >= 100:
				GameApi.add_weight(weights, cur_country, to, GameData.Operation.DeclareWar, 100.)

			if cur_relation.status == GameData.DiplomaticStatus.OPEN_WAR:
				# war resolution
				if countries[to].treasury <= 0:
					GameApi.add_weight(weights, cur_country, to, GameData.Operation.AskForPeace, maxf(10 * w_armies, 0.))
				if countries[to].armies <= 0:
					GameApi.add_weight(weights, cur_country, to, GameData.Operation.Subjugate, 100.)
				if countries[cur_country].treasury <= 0:
					GameApi.add_weight(weights, cur_country, to, GameData.Operation.AskForPeace, maxf(- 10 * w_armies, 0.))
				if countries[cur_country].armies <= 0:
					GameApi.add_weight(weights, cur_country, to, GameData.Operation.AskForMercy, 100.)
				if countries[cur_country].armies <= 0:
					GameApi.add_weight(weights, cur_country, to, GameData.Operation.AskForMercy, 100.)
				
				GameApi.add_weight(weights, cur_country, to, GameData.Operation.SendTroop, maxf(10 * w_armies, 0.))
				GameApi.add_weight(weights, cur_country, to, GameData.Operation.Recruit, maxf(- w_armies, 0.))

		# pacific suspicion decision
		GameApi.add_weight(weights, cur_country, to, GameData.Operation.Covert, maxf(10 * w(cur_relation.suspicion, 50), 0.))
		GameApi.add_weight(weights, cur_country, to, GameData.Operation.Spy, maxf(10 * w(cur_relation.suspicion, 25), 0.))

		# economic decision
		GameApi.add_weight(weights, cur_country, to, GameData.Operation.Invest, maxf(10 * w_treasury, 0.))

static func choose(
	weights: Dictionary[Vector3i, float], 
	cur_country: int,
	rng: RandomNumberGenerator
) -> OperationData:
	# x = from, y = to, z = op
	var key: Vector3i = Vector3i(cur_country, cur_country, GameData.Operation.Invest)
	
	var sum_weight: float = 0.
	for k in weights:
		if k.x != cur_country:
			continue
		sum_weight += weights[k]

	if sum_weight <= .0:
		return OperationData.new(key)

	var rnd: float = rng.randf_range(0., sum_weight)
	
	var cum_weight: float = 0
	for k in weights:
		if k.x != cur_country:
			continue
		cum_weight += weights[k]
		if cum_weight >= rnd:
			key = k
			break

	return OperationData.new(key)
