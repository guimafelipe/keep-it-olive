extends Area

var RockClass = preload("res://Scripts/Rock.gd")

var tree
var min_dist_to_tree = 4

var approach_speed = 3
var flee_speed = 9
var dir = Vector3()

enum states {APPROACHING, FIRING, FLEETING}
var state

func search_for_tree():
	var trees = get_parent().get_node("Trees").get_children()
	var chosen_tree
	var best_dist = INF
	
	for tree in trees:
		if tree.state == tree.states.IDLE and not tree.is_targeted:
			var dist = get_dist_to_tree(tree)
			if dist < best_dist:
				best_dist = dist
				chosen_tree = tree
	
	if chosen_tree == null:
		print("Nao achei arvore")
		queue_free()
		return
	
	self.tree = chosen_tree
	self.tree.set_targeted(true)
	define_movement()

func define_movement():
	dir = tree.global_transform.origin - global_transform.origin
	dir.y = 0
	dir = dir.normalized()
	

func init():
	search_for_tree()
	state = states.APPROACHING
	$MeshHandler/Enemy/AnimationPlayer.play("default")
	var tree_pos = tree.global_transform.origin
	tree_pos.y = global_transform.origin.y
	look_at(tree_pos, Vector3.UP)
	rotate_y(PI)
	#print("Nasci")

# warning-ignore:shadowed_variable
func get_dist_to_tree(tree):
	return global_transform.origin.distance_to(tree.global_transform.origin)

func _on_FiringTimer_timeout():
	tree.on_fire()
	fleet()

func fleet():
	state = states.FLEETING
	$FleetingTimer.start()
	rotate_y(PI)

func hit():
	if state == states.FIRING:
		tree.stop_firing()
	tree.set_targeted(false)
	# do hit animation
	$FiringTimer.stop()
	fleet()

func _on_Enemy_body_entered(body):
	if body is RockClass:
		hit()
		body.destroy()

func _on_FleetingTimer_timeout():
	queue_free()

func _physics_process(delta):
	match state:
		states.APPROACHING:
			self.global_transform.origin += dir*approach_speed*delta
			print(dir)
			print(global_transform.origin)
			if get_dist_to_tree(tree) <= min_dist_to_tree:
				state = states.FIRING
				# do firing animation
				# do firing animation on tree
				tree.firing()
				$FiringTimer.start()
				
				
		states.FIRING:
			pass
		states.FLEETING:
			self.global_transform.origin += -dir*flee_speed*delta

func _ready():
	pass


