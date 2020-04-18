extends KinematicBody

onready var camera = $Pivot/Camera

# movement variables
var max_speed = 8
var mouse_sensitivity = 0.002 # radians/pixel

var velocity = Vector3()

# shot variables
var bullet = preload("res://Scenes/Rock.tscn")
var shoot_range = 1000
var camera_width_center = 0
var camera_height_center = 0
var shoot_origin = Vector3()
var shoot_normal = Vector3()
var shooting = 0

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("move_forward"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir +=  camera.global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		input_dir +=  camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)

func shoot_rock():
	shoot_origin = camera.project_ray_origin(Vector2(camera_width_center, camera_height_center))
	shoot_normal = camera.project_ray_normal(Vector2(camera_width_center, camera_height_center)) * shoot_range
	var clone = bullet.instance()
	var scene_root = get_tree().root.get_children()[0]
	scene_root.add_child(clone)
	clone.global_transform = $Pivot/Camera.global_transform
	clone.init()

func _physics_process(_delta):
	var desired_velocity = get_input() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	if Input.is_action_just_pressed("shoot"):
		shoot_rock()

func _ready():
	camera_width_center = OS.get_window_size().x / 2
	camera_height_center = OS.get_window_size().y / 2
