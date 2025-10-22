extends RefCounted

class_name UnlockableGraph

var nodes: Set
var edges: Set
var _queue: Array
var _degrees: Dictionary[Variant, int]
var _adj: Dictionary[Variant, Array]
var _not_prepared: bool

func _init() -> void:
	nodes = Set.new()
	edges = Set.new()
	_queue = []
	_degrees = {}
	_adj = {}
	_not_prepared = true

func add(unlockable_node: UnlockableNode) -> void:
	nodes.add(unlockable_node)

	for dep in unlockable_node.dependencies:
		edges.add([dep, unlockable_node])
	_not_prepared = true

func prepare() -> void:
	if _not_prepared:
		_adj = KhanSorter.adjacency(nodes, edges)
		KhanSorter.prepare_sort(nodes, _queue, _degrees, _adj)
		_not_prepared = false

func is_unlockable(unlockable_node: UnlockableNode) -> bool:
	prepare()
	return unlockable_node in _queue

func unlock(unlockable_node: UnlockableNode) -> void:
	prepare()
	if unlockable_node == null:
		return
	var position_queue: int = _queue.find(unlockable_node)
	if position_queue == -1:
		push_error("Not Found")
		return

	var node = _queue.pop_at(position_queue)
	for neighbor: Variant in _adj[node]:
		_degrees[neighbor] -= 1
		if _degrees[neighbor] == 0:
			_queue.push_back(neighbor)

	unlockable_node.unlocked()

func get_next_unlock() -> UnlockableNode:
	prepare()
	if _queue.is_empty():
		return null
	return _queue[0]

func sort() -> Array:
	return KhanSorter.sort(nodes, edges)
