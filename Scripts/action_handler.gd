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
	var key: Vector3i

	var sum_weight: float = 0.
	for k in weights:
		if k.x != cur_country:
			continue
		sum_weight += weights[k]

	if sum_weight <= .0:
		push_error("invalid sum weight: %s" % sum_weight)

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


static func resolve(
	countries: Dictionary[int, CountryData],
	relations: Relations, 
	op_data: OperationData,
	rng: RandomNumberGenerator
) -> void:
	var cur_country: CountryData = countries[op_data.who]
	var target_country: CountryData = countries[op_data.target]
	var cur_relation = relations.get_relation(op_data.who, op_data.target)
	var target_relation = relations.get_relation(op_data.target, op_data.who)
	match op_data.op:
		GameData.Operation.Invest:
			#TODO: moves magic number to AiConfig once the model is written
			var advantage_treasury: float = advantage(cur_country.treasury, target_country.treasury)
			var invest_chance: float = .6
			var redistribution_chance: float = .2
			var amount_invest: float = cur_country.treasury * advantage_treasury
			if cur_relation.status == GameData.DiplomaticStatus.ECONOMIC_RELATION:
				invest_chance *= 1.5
			if target_relation.status == GameData.DiplomaticStatus.ECONOMIC_RELATION:
				redistribution_chance *= 1.5
			var invest: float = rng.randf()
			var redistribution: float = rng.randf()

			if invest <= invest_chance:
				if redistribution <= redistribution_chance:
					cur_country.treasury += int(amount_invest * advantage_treasury)
					target_country.treasury += int(amount_invest * (1. - advantage_treasury))
				else:
					cur_country.treasury += int(amount_invest * advantage_treasury)
					target_country.treasury -= int(amount_invest * advantage_treasury)
			else:
				cur_country.treasury -= int(amount_invest)

		GameData.Operation.Spy:
			print("not implemented")
		GameData.Operation.Covert:
			print("not implemented")
		GameData.Operation.DeclareWar:
			print("not implemented")
		GameData.Operation.AskForPeace:
			print("not implemented")
		GameData.Operation.AskForMercy:
			print("not implemented")
		GameData.Operation.ImposePeace:
			print("not implemented")
		GameData.Operation.Subjugate:
			print("not implemented")
		GameData.Operation.SendTroop:
			print("not implemented")
		GameData.Operation.Recruit:
			print("not implemented")
		_:
			push_error("invalid operation: %s" % op_data.op)

	# TODO: this is a placeholder
	cur_country.lock_in_operation = rng.randi_range(3, 7)