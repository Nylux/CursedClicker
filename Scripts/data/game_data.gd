class_name GameData extends RefCounted

enum StatLevel {
	LOW = -1,
	MID = 0,
	HIGH = 1,
}

static func compute_efficiency(primary: GameData.StatLevel, secondary: GameData.StatLevel) -> float:
	var raw: int = 2*primary + secondary

	match raw:
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
		_:
			return .0


enum DiplomaticStatus {
	NO_RELATION,
	OPEN_WAR,
	ECONOMIC_RELATION,
}

enum Stance {
	NEUTRAL,
}

enum Hierarchy {
	NONE,
	OVERLORD,
	CLIENT_STATE
}

const PLAYER_ID = 0
const COUNTRY_0_ID = 1
const COUNTRY_1_ID = 2

enum Operation {
	Invest,
	Spy,
	Covert,
	DeclareWar,
	AskForPeace,
	AskForMercy,
	ImposePeace,
	Subjugate,
	SendTroop,
	Recruit,
}
