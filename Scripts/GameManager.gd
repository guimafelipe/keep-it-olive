extends Node

onready var main_terrain = get_parent()
var trees
var spawners
var dead_trees = 0
var trees_on_fire = 0
const MAX_DEAD_TREES = 15
signal dead_trees(val, lim)
signal trees_on_fire(val)
signal updated_points(pts, dif)

var current_time = 0
var difficulty = 0
var points = 0
var lost = false

func spawn_enemy():
	var n = len(spawners)
	randomize()
	var i = randi()%n
	spawners[i].spawn_enemy()

func _on_SpawnTimer_timeout():
	spawn_enemy()
	$SpawnTimer.wait_time = GameData.interval_time[difficulty]
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

func _process(delta):
	current_time += delta
	var new_diff = 0
	for i in range(GameData.difficulty_map.size()):
		if current_time >= GameData.difficulty_map[i]:
			new_diff = i
	difficulty = new_diff
	assert(difficulty <= GameData.max_difficulty)
	if(current_time - points > 1 and not lost):
		points+=1
		emit_signal("updated_points", points, difficulty)
	
func _ready():
	trees = main_terrain.get_node("Trees").get_children()
	spawners = main_terrain.get_node("Spawners").get_children()
	$SpawnTimer.wait_time = GameData.first_spawn_time
	$SpawnTimer.start()
	for tree in trees:
		tree.connect("died", self, "on_Tree_Died")
		tree.connect("on_fire", self, "on_Tree_on_Fire")
		tree.connect("exit_fire", self, "on_Tree_Exit_Fire")
	emit_signal("dead_trees", dead_trees, MAX_DEAD_TREES)
	emit_signal("trees_on_fire", trees_on_fire)
	emit_signal("updated_points", points, difficulty)
