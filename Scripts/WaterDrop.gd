extends RigidBody

const KILL_TIME = 4 # time for bullet vanish
var timer = 0

var TreeClass = preload("res://Scripts/Tree.gd")

var hit_something = false
var throw_impulse = 20.0

func destroy():
	# spawn particles?
	queue_free()

func init(normal):
	var forward_dir = normal.normalized() # -global_transform.basis.z.normalized()
	set_linear_velocity(throw_impulse*forward_dir)
	set_physics_process(true)

func _on_WaterDrop_body_entered(body):
	if body is TreeClass:
		body.take_water()
	destroy()

func _physics_process(delta):
	timer += delta
	#look_at(linear_velocity, Vector3.RIGHT)
	if timer >= KILL_TIME:
		queue_free()

func _ready():
	# axis_lock_angular_z = true
	set_contact_monitor(true)
	set_max_contacts_reported(3)


