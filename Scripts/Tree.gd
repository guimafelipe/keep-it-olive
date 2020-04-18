extends Spatial

enum states {IDLE, FIRING, ON_FIRE, WATERING, DEAD}
var state
signal died
var is_targeted = false

var water_level = 0
const WATER_NEEDED = 16

func set_targeted(val):
	is_targeted = val

func change_color(color):
	$StaticBody/MeshInstance.get_surface_material(0).set_shader_param("albedo", color)

func firing():
	state = states.FIRING
	# do firing animation
	change_color(Color(0.5, 0.5, 0))

func stop_firing():
	if state == states.FIRING:
		# change to idle mesh
		state = states.IDLE
		$FireTimer.stop()
		change_color(Color(0, 1, 0))

func on_fire():
	state = states.ON_FIRE
	# do on fire animation
	$FireTimer.start()
	change_color(Color(1, 0, 0))

func die():
	state = states.DEAD
	# change to dead tree mesh
	emit_signal("died")
	change_color(Color(0, 0, 0))

func _on_FireTimer_timeout():
	die()

func _ready():
	state = states.IDLE
	var mat = $StaticBody/MeshInstance.get_surface_material(0).duplicate()
	$StaticBody/MeshInstance.set_surface_material(0, mat)
