class_name Random extends RefCounted


static func fydk_shuffling(array: PackedInt32Array) -> void:
	var tt: int = array.size()
	if tt == 0:
		return

	var j: int = tt - 1
	var k: int = 0
	var temp: int

	var x: int
	var max_for_mod: int = INT32_MAX - INT32_MAX % tt

	while j > 0:
		while true:
			x = randi()
			if x < max_for_mod:
				k = x % tt
				break

		temp = array[k]
		array[k] = array[j]
		array[j] = temp

		j -= 1


# Araujo, L.C., Sansão, J.P.H. & Vale-Cardoso, A.S. Fast computation of binomial coefficients. Numer Algor 86, 799–812 (2021). https://doi.org/10.1007/s11075-020-00912-x
# Yannis Manolopoulos. 2002. Binomial coefficient computation: recursion or iteration? SIGCSE Bull. 34, 4 (December 2002), 65–67. https://doi.org/10.1145/820127.820168
static func binomial_coefficient_ym(n: int, t: int) -> int:
	if t > n: return 0
	var res: int = 1

	if t != 0 and t != n:
		if t > (n - t): t = n-t
		for i: int in range(t):
			@warning_ignore("integer_division")
			res = (res * (n-i)) / (i+1)

	return res


# from Knuth Donald, The Art Of Computer Programming, Volume 4A, Third Edition
# 7.2.1.3 Answers to Exercises, p727
# Answer 17
static func decode_combinatorial_number_system(coded: int, t: int) -> PackedInt32Array:
	var res: PackedInt32Array = PackedInt32Array()
	var _discard: int = res.resize(t)

	var x: int = 1
	var c: int = t

	while x <= coded:
		c += 1
		@warning_ignore("integer_division")
		x = (x*c) / (c-t)
	
	@warning_ignore("integer_division")
	x = x * (c-t) / c
	c -= 1

	while t > 1:
		res[t-1] = c
		coded -= x

		@warning_ignore("integer_division")
		x = x*t / c
		t -= 1
		c -= 1
		while x > coded:
			@warning_ignore("integer_division")
			x = x * (c-t) / c
			c -= 1
	
	res[0] = coded
	return res


static func get_random_combination(n: int, t: int) -> PackedInt32Array:
	if t == 0:
		return PackedInt32Array()

	# if n > 50:
		# push_error("Computing combinations with a population size greater than 50 may introduced some errors.")
	var c: int = binomial_coefficient_ym(n, t)
	var i: int = randi_range(0, c - 1)
	return decode_combinatorial_number_system(i, t)
