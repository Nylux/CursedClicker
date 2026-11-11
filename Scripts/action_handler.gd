class_name ActionHandler extends RefCounted


static func sig(x) -> float:
	return 1. / (1. + exp(-x))


static func advantage(x: float, y: float) -> float:
	return sig((x - y) / AiConfig.ADVANTAGE_NORMALIZATION)


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
		var advantage_armies: float = advantage(countries[cur_country].armies, countries[to].armies)
		var advantage_treasury: float = advantage(countries[cur_country].treasury, countries[to].treasury)

		if GameApi.is_client_state_of(to_relation, cur_relation) and advantage_armies > 0.:
			if cur_relation.status == GameData.DiplomaticStatus.OPEN_WAR:
				GameApi.add_weight(weights, cur_country, to, GameData.Operation.ImposePeace, AiConfig.WEIGHT_IMPOSE_PEACE)
		else:
			if cur_relation.suspicion >= 100:
				GameApi.add_weight(weights, cur_country, to, GameData.Operation.DeclareWar, AiConfig.WEIGHT_DECLARE_WAR)

			if cur_relation.status == GameData.DiplomaticStatus.OPEN_WAR:
				# war resolution
				if countries[to].treasury <= 0:
					GameApi.add_weight(weights, cur_country, to, GameData.Operation.AskForPeace, AiConfig.WEIGHT_ASK_FOR_PEACE * advantage_armies)
				if countries[to].armies <= 0:
					GameApi.add_weight(weights, cur_country, to, GameData.Operation.Subjugate, AiConfig.WEIGHT_SUBJUGATE)
				if countries[cur_country].treasury <= 0:
					GameApi.add_weight(weights, cur_country, to, GameData.Operation.AskForPeace, AiConfig.WEIGHT_ASK_FOR_PEACE * (1. - advantage_armies))
				if countries[cur_country].armies <= 0:
					GameApi.add_weight(weights, cur_country, to, GameData.Operation.AskForMercy, AiConfig.WEIGHT_ASK_FOR_MERCY) 
				
				GameApi.add_weight(weights, cur_country, to, GameData.Operation.SendTroop, AiConfig.WEIGHT_SEND_TROOP * advantage_armies)
				GameApi.add_weight(weights, cur_country, to, GameData.Operation.Recruit, AiConfig.WEIGHT_RECRUIT * (1. - advantage_armies))

		# pacific suspicion decision
		GameApi.add_weight(weights, cur_country, to, GameData.Operation.Covert, AiConfig.WEIGHT_COVERT * advantage(cur_relation.suspicion , AiConfig.COVERT_SUSPICION_LEVEL))
		GameApi.add_weight(weights, cur_country, to, GameData.Operation.Spy, AiConfig.WEIGHT_SPY * advantage(cur_relation.suspicion, AiConfig.SPY_SUSPICION_LEVEL))

		# economic decision
		GameApi.add_weight(weights, cur_country, to, GameData.Operation.Invest, AiConfig.WEIGHT_INVEST * advantage_treasury)

static func choose(
	weights: Dictionary[Vector3i, float], 
	cur_country: int,
	rng: RandomNumberGenerator
) -> OperationData:
	# x = from, y = to, z = op
	# self invest if nothing else is available, else not
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
