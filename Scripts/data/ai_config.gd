class_name AiConfig extends RefCounted

#
const DECAY_WEIGHT: float = .95

# flat weight
const WEIGHT_IMPOSE_PEACE: float = 100.
const WEIGHT_DECLARE_WAR: float = 100.
const WEIGHT_SUBJUGATE: float = 100.
const WEIGHT_ASK_FOR_MERCY: float = 100.

# scaled weight
const WEIGHT_ASK_FOR_PEACE: float = 10.
const WEIGHT_SEND_TROOP: float = 10.
const WEIGHT_RECRUIT: float = 1.
const WEIGHT_COVERT: float = 10.
const WEIGHT_SPY: float = 10.
const WEIGHT_INVEST: float = 10.

# other
const COVERT_SUSPICION_LEVEL: int = 50
const SPY_SUSPICION_LEVEL: int = 25

const ADVANTAGE_NORMALIZATION: float = 10.