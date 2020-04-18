extends Spatial

enum states {IDLE, FIRING, ON_FIRE, WATERING, DEAD}
var state
signal died
var is_targeted = false

func set_targeted(val):
	is_targeted = val

func firing():
	state = states.FIRING
	# do firing animation

func on_fire():
	state = states.ON_FIRE
	# do on fire animation
	$FireTimer.start()

func die():
	state = states.DEAD
	# change to dead tree mesh
	emit_signal("died")

func _ready():
	state = states.IDLE
