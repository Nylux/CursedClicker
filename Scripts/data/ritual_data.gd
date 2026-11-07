class_name RitualData extends RefCounted

var cur_progress: float = .0
var power: float =  .05
var worker_as_fraction: float = .0

const K: float = 100.0

func add_power(value: float) -> void:
	power += value

func progress(game_state: GameState) -> void:
	cur_progress += power * (K + get_workers(game_state.current_cultist)) / K
	while cur_progress >= 1.0:
		cur_progress -= 1.0
		game_state.add_cultist(1)
	
	EventBus.data_changed.emit()

func set_workers(fraction: float) -> void:
	worker_as_fraction = fraction

func get_workers(current_cultist: int) -> int:
	return int(worker_as_fraction * current_cultist)