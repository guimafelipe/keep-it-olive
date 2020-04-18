extends Spatial

enum states {IDLE, FIRING, ON_FIRE, WATERING, DEAD}
var state

func _ready():
	state = states.IDLE
