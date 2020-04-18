extends RigidBody

const KILL_TIME = 4 # time for bullet vanish
var timer = 0

var hit_something = false
var throw_impulse = 20.0

func destroy():
	# spawn particles?
	queue_free()

func init():
	var forward_dir =  -global_transform.basis.z.normalized()
	set_linear_velocity(throw_impulse*forward_dir)
	set_physics_process(true)


func _on_Rock_body_entered(body):
	destroy()

func _physics_process(delta):
	timer += delta
	if timer >= KILL_TIME:
		queue_free()

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(1)

