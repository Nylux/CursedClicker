class_name GameState extends RefCounted

# resources values
var total_blood: int
var total_corruption: int
var current_blood: int
var current_corruption: int

const MAX_POPULATION: int = 8_253_443_180
var current_population: int
var current_cultist: int
var current_zealot: int
var current_infiltrator: int

# game values
var click_multiplier: int

func _ready() -> void:
	reset()
	EventBus.blood_created.connect(_on_blood_created)
	EventBus.corruption_created.connect(_on_corruption_created)
	EventBus.cultist_created.connect(_on_cultist_created)
	EventBus.sacrifice_created.connect(_on_cultist_sacrificied)


func _on_blood_created(value: int):
	current_blood += value
	total_blood += value
	if total_blood >= 1:
		FeaturesGraph.unlock_node(FeaturesGraph.rituals_stat)
	if total_blood >= 5:
		FeaturesGraph.unlock_node(FeaturesGraph.rituals_stat_power)

	EventBus.data_changed.emit()


func _on_corruption_created(value: int):
	current_corruption += value
	total_corruption += value

	EventBus.data_changed.emit()


func _on_cultist_created(amount: int):
	current_population -= amount
	current_cultist += amount
	EventBus.cultist_changed.emit(current_cultist)
	EventBus.data_changed.emit()

func _on_cultist_sacrificied(amount: int):
	var sacrificied_amout: int = min(amount, current_cultist)
	current_cultist -= sacrificied_amout
	EventBus.blood_created.emit(sacrificied_amout)
	EventBus.cultist_changed.emit(current_cultist)
	EventBus.data_changed.emit()


func reset() -> void:
	total_blood = 0
	total_corruption = 0
	current_blood = 0
	current_corruption = 0
	current_population = MAX_POPULATION
	current_cultist = 0
	current_zealot = 0
	current_infiltrator = 0

	click_multiplier = 1
	EventBus.data_changed.emit()
