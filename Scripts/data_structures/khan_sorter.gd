extends RefCounted

class_name KhanSorter

static func adjacency(nodes: Set, edges: Set) -> Dictionary[Variant, Array]:
	var adj: Dictionary[Variant, Array] = {}

	for node: Variant in nodes.get_all():
		adj[node] = []

	for edge: Array in edges.get_all():
		var from: Variant = edge[0]
		var to: Variant = edge[1]
		adj[from].append(to)

	return adj

static func prepare_sort(nodes: Set, queue: Array, degrees: Dictionary[Variant, int], adj: Dictionary[Variant, Array]):
	for node: Variant in nodes.get_all():
		degrees[node] = 0

	for node: Variant in nodes.get_all():
		for neighbor: Variant in adj[node]:
			degrees[neighbor] += 1

	for node: Variant in degrees:
		if degrees[node] == 0:
			queue.append(node)

static func step_sort(queue: Array, degrees: Dictionary[Variant, int], adj: Dictionary[Variant, Array]) -> Variant:
	var node: Variant = queue.pop_front()

	for neighbor: Variant in adj[node]:
		degrees[neighbor] -= 1
		if degrees[neighbor] == 0:
			queue.push_back(neighbor)

	return node

static func sort(nodes: Set, edges: Set) -> Array[Variant]:
	var sorted: Array[Variant] = []
	var degrees: Dictionary[Variant, int] = {}
	var queue: Array[Variant] = []
	var adj: Dictionary[Variant, Array] = adjacency(nodes, edges)
	prepare_sort(nodes, queue, degrees, adj)

	while queue.size() > 0:
		var node: Variant = step_sort(queue, degrees, adj)
		sorted.append(node)
				
	if nodes.size() > sorted.size():
		push_error("A cycle was detected while doing a Khan Topological Sorter, the input should be a DAG.")

	return sorted
