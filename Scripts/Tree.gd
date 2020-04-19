extends Spatial

enum states {IDLE, FIRING, ON_FIRE, WATERING, DEAD}
var state
signal died
signal on_fire
signal exit_fire
var is_targeted = false

var water_level = 0
const WATER_NEEDED = 160
var water_delay
var water_cd = 3

func set_targeted(val):
	is_targeted = val

func change_color(color):
	$MeshInstance.get_surface_material(0).set_shader_param("albedo", color)

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

func successful_watering():
	if state == states.WATERING:
		# change to idle mesh
		state = states.IDLE
		$WaterTimer.stop()
		change_color(Color(0, 1, 0))
		is_targeted = false
		emit_signal("exit_fire")
		$Fire.set_emitting(false)

func on_fire():
	state = states.ON_FIRE
	# do on fire animation
	$Fire.set_emitting(true)
	$FireTimer.start()
	water_level = 0
	change_color(Color(1, 0, 0))
	emit_signal("on_fire")

func die():
	state = states.DEAD
	# change to dead tree mesh
	emit_signal("died")
	change_color(Color(0, 0, 0))
	$Tree.set_visible(false)
	$BurntTree2.set_visible(true)
	$Fire.set_emitting(false)
	$Smoke.set_emitting(true)

func take_water():
	if state == states.ON_FIRE:
		start_watering()
	elif state != states.WATERING:
		return
	water_level += 1
	if water_level >= WATER_NEEDED:
		successful_watering()
		return
	$WaterTimer.start()

func start_watering():
	state = states.WATERING
	change_color(Color(0, 0, 1))
	water_level = 0
	$FireTimer.stop()
	$WaterTimer.start()

func _on_WaterTimer_timeout():
	on_fire()

func _on_FireTimer_timeout():
	die()

func _ready():
	state = states.IDLE
	var mat = $MeshInstance.get_surface_material(0).duplicate()
	$MeshInstance.set_surface_material(0, mat)

