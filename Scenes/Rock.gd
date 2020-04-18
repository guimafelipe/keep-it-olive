extends RigidBody

const KILL_TIME = 4 # time for bullet vanish
var timer = 0

var hit_something = false
var throw_impulse = 20.0

func init():
	var forward_dir =  -global_transform.basis.z.normalized()
	set_linear_velocity(throw_impulse*forward_dir)
	set_physics_process(true)

func _physics_process(delta):
	timer += delta
	if timer >= KILL_TIME:
		queue_free()

func _ready():
	pass
