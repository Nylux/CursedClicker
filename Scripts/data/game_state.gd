class_name GameState extends RefCounted

const MAX_POPULATION: int = 8_253_443_180

# resources values
var total_blood: int
var total_corruption: int
var total_cultist: int
var total_zealot: int
var total_infiltrator: int

var current_blood: int
var current_corruption: int
var current_population: int
var current_cultist: int
var current_zealot: int
var current_infiltrator: int

var ritual_workers: int

var faith: GameData.StatLevel
var discipline: GameData.StatLevel
var moral: GameData.StatLevel
var knowledge: GameData.StatLevel

# game values
var features: UnlockableGraph
var click_multiplier: int

# panel data
var ritual_data: RitualData

# countries data
var countries: Dictionary[int, CountryData]
var relations: Relations
var weights: Dictionary[Vector3i, int]


func _init() -> void:
	reset()


func add_blood(amount: int):
	assert(amount >= 0)
	current_blood += amount
	total_blood += amount
	if total_blood >= 1:
		GameApi.try_unlock_node(self, FeaturesNode.rituals_stat)
	if total_blood >= 5:
		GameApi.try_unlock_node(self, FeaturesNode.rituals_stat_power)

	EventBus.data_changed.emit()


func add_corruption(amount: int):
	assert(amount >= 0)
	current_corruption += amount
	total_corruption += amount

	EventBus.data_changed.emit()


func add_cultist(amount: int):
	assert(amount >= 0)
	current_population -= amount
	current_cultist += amount
	total_cultist += amount

	if total_cultist:
		GameApi.try_unlock_node(self, FeaturesNode.altar)

	EventBus.data_changed.emit()


func cultist_sacrificied(amount: int):
	assert(amount >= 0)
	var sacrificied_amout: int = min(amount, current_cultist)
	current_cultist -= sacrificied_amout

	add_blood(sacrificied_amout)
	EventBus.data_changed.emit()


func reset() -> void:
	total_blood = 0
	total_corruption = 0
	total_cultist = 0
	total_zealot = 0
	total_infiltrator = 0

	current_blood = 0
	current_corruption = 0
	current_population = MAX_POPULATION
	current_cultist = 0
	current_zealot = 0
	current_infiltrator = 0

	click_multiplier = 1

	features = UnlockableGraph.new()
	for n: UnlockableNode in FeaturesNode.nodes:
		n.connect_unlocked(GameApi._on_node_unlocked.bind(n))
		features.add(n)

	ritual_data = RitualData.new()
	ritual_workers = 0

	
	faith = GameData.StatLevel.MID
	discipline = GameData.StatLevel.MID
	moral = GameData.StatLevel.MID
	knowledge = GameData.StatLevel.MID


	countries = {
		GameData.PLAYER_ID: CountryData.new("player"),
		GameData.COUNTRY_0_ID: CountryData.new("test"),
		GameData.COUNTRY_1_ID: CountryData.new("test2"),
	}

	relations = Relations.new()
	var _discard: RelationData
	var number_relations = Random.binomial_coefficient_ym(countries.size(), 2)
	for i in range(number_relations):
		var pair: PackedInt32Array = Random.decode_combinatorial_number_system(i, 2)
		_discard = relations.get_relation(pair[0], pair[1])

	weights = {}
	for to in countries:
		for from in countries:
			if from == GameData.PLAYER_ID or to == from:
				continue
			for op in GameData.Operation.values():
				GameApi.init_weight(weights, from, to, op)

	EventBus.data_changed.emit()


func set_ritual_workers(amount: int) -> void:
	ritual_workers = int(amount / 100.0 * current_cultist)

	EventBus.data_changed.emit()
	# add logic if multiple workers are used to avoid Sum > current_cultist


func get_current_cultist() -> int:
	return current_cultist


func get_ritual_workers() -> int:
	return ritual_workers


func get_ritual_workers_percent() -> float:
	if current_cultist <= 0:
		return 0.
	return ritual_workers / float(current_cultist) * 100.0


func progress_ritual() -> void:
	var cultist_to_add = ritual_data.progress(get_ritual_workers(), religious_eff())
	add_cultist(cultist_to_add)


func religious_eff() -> float:
	return 1.0 + GameData.compute_efficiency(self.faith, self.discipline)


func combat_eff() -> float:
	return 1.0 + GameData.compute_efficiency(self.discipline, self.moral)


func mental_eff() -> float:
	return 1.0 + GameData.compute_efficiency(self.moral, self.knowledge)


func research_eff() -> float:
	return 1.0 + GameData.compute_efficiency(self.knowledge, self.faith)
