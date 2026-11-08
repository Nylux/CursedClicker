class_name RitualData extends RefCounted

var cur_progress: float = .0
var power: float =  .05

const K: float = 100.0

func add_power(value: float) -> void:
	power += value

func progress(workers: int) -> int:
	cur_progress += power * (K + workers) / K

	var completed = int(cur_progress)
	cur_progress -= completed

	return completed
