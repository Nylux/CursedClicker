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

# game values
var features: UnlockableGraph
var click_multiplier: int

signal cultist_created(amount)
signal sacrifice_created(amount)
signal blood_created(amount)
signal corruption_created(amount)


func _init() -> void:
	reset()
	blood_created.connect(_on_blood_created)
	corruption_created.connect(_on_corruption_created)
	cultist_created.connect(_on_cultist_created)
	sacrifice_created.connect(_on_cultist_sacrificied)


func _on_blood_created(amount: int):
	assert(amount >= 0)
	current_blood += amount
	total_blood += amount
	if total_blood >= 1:
		GameApi.unlock_node(self, FeaturesNode.rituals_stat)
	if total_blood >= 5:
		GameApi.unlock_node(self, FeaturesNode.rituals_stat_power)

	EventBus.data_changed.emit()


func _on_corruption_created(amount: int):
	assert(amount >= 0)
	current_corruption += amount
	total_corruption += amount

	EventBus.data_changed.emit()


func _on_cultist_created(amount: int):
	assert(amount >= 0)
	current_population -= amount
	current_cultist += amount
	total_cultist += amount

	if total_cultist:
		GameApi.unlock_node(self, FeaturesNode.altar)

	EventBus.data_changed.emit()


func _on_cultist_sacrificied(amount: int):
	assert(amount >= 0)
	var sacrificied_amout: int = min(amount, current_cultist)
	current_cultist -= sacrificied_amout

	blood_created.emit(sacrificied_amout)
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

	EventBus.data_changed.emit()
