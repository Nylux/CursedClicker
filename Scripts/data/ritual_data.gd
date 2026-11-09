class_name RitualData extends RefCounted

var cur_progress: float = .0
var power: float =  .05

const K: float = 100.0

func add_power(value: float) -> void:
	power += value

func progress(workers: int, eff: float) -> int:
	cur_progress += power * (K + workers) / K * eff

	var completed = int(cur_progress)
	cur_progress -= completed

	return completed
