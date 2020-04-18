extends Area

var tree
var min_dist_to_tree = 3

var approach_speed = 3
var flee_speed = 9
var dir = Vector3()

enum states {APPROACHING, FIRING, FLEETING}

func search_for_tree():
	var trees = get_parent().get_node("Trees").get_children()
	var chosen_tree
	var best_dist = INF
	
	for tree in trees:
		if tree.state == tree.states.IDLE:
			var dist = global_transform.origin.distance_to(tree.global_transform.origin)
			if dist < best_dist:
				best_dist = dist
				chosen_tree = tree
	
	if chosen_tree == null:
		print("Nao achei arvore")
		queue_free()
		return
	
	self.tree = chosen_tree

func define_movement():
	dir = tree.global_transform.origin - global_transform.origin
	dir.y = 0
	dir = dir.normalized()
	

func init():
	search_for_tree()
	define_movement()
	print("Nasci")

func _physics_process(delta):
	self.translate(dir*approach_speed*delta)

func _ready():
	pass
