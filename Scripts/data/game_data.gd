class_name GameData extends RefCounted

enum StatLevel {
	LOW = -1,
	MID = 0,
	HIGH = 1,
}

static func compute_efficiency(primary: GameData.StatLevel, secondary: GameData.StatLevel) -> float:
	var raw: int = 2*primary + secondary - 3

	match raw:
		0:
			return .0
		1:
			return .33
		2:
			return .66
		3:
			return 1.
		-1:
			return -.25
		-2:
			return -.40
		-3:
			return -.5