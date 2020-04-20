extends RigidBody

const KILL_TIME = 3 # time for bullet vanish
var timer = 0

var hit_something = false
var throw_impulse = 20.0
var destroyed = false


func destroy():
	# spawn particles?
	if destroyed:
		return
	destroyed = true
	var particles = $RockParticles
	self.remove_child(particles)
	get_parent().add_child(particles)
	particles.transform = transform.basis
	particles.transform.origin = transform.origin
	particles.set_scale(Vector3(0.4,0.4,0.4))
	particles.set_direction(-get_linear_velocity().normalized())
	particles.set_emitting(true)
	particles.get_node("Timer").start()
	queue_free()

func init(normal):
	var forward_dir = normal.normalized() # -global_transform.basis.z.normalized()
	set_linear_velocity(throw_impulse*forward_dir)
	set_physics_process(true)

func _on_Rock_body_entered(_body):
	destroy()

func _physics_process(delta):
	timer += delta
	if timer >= KILL_TIME:
		queue_free()

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(1)

