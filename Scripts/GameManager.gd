extends Node

onready var main_terrain = get_parent()
var trees
var spawners
var dead_trees = 0
var trees_on_fire = 0
const MAX_DEAD_TREES = 15
signal dead_trees(val, lim)
signal trees_on_fire(val)

func spawn_enemy():
	var n = len(spawners)
	randomize()
	var i = randi()%n
	spawners[i].spawn_enemy()

func _on_SpawnTimer_timeout():
	spawn_enemy()
	$SpawnTimer.start()

func end_game():
	pass

func on_Tree_Died():
	dead_trees += 1
	emit_signal("dead_trees", dead_trees, MAX_DEAD_TREES)
	if dead_trees >= MAX_DEAD_TREES:
		end_game()

func on_Tree_on_Fire():
	trees_on_fire += 1
	emit_signal("trees_on_fire", trees_on_fire)

func on_Tree_Exit_Fire():
	trees_on_fire -= 1
	emit_signal("trees_on_fire", trees_on_fire)

func _ready():
	trees = main_terrain.get_node("Trees").get_children()
	spawners = main_terrain.get_node("Spawners").get_children()
	$SpawnTimer.wait_time = 4
	$SpawnTimer.start()
	for tree in trees:
		tree.connect("died", self, "on_Tree_Died")
		tree.connect("on_fire", self, "on_Tree_on_Fire")
		tree.connect("exit_fire", self, "on_Tree_Exit_Fire")
	emit_signal("dead_trees", dead_trees, MAX_DEAD_TREES)
	emit_signal("trees_on_fire", trees_on_fire)
