extends Node

onready var main_terrain = get_parent()
var trees
var spawners

func spawn_enemy():
	var n = len(spawners)
	randomize()
	var i = randi()%n
	spawners[i].spawn_enemy()

func _on_SpawnTimer_timeout():
	spawn_enemy()
	$SpawnTimer.start()

func _ready():
	trees = main_terrain.get_node("Trees").get_children()
	spawners = main_terrain.get_node("Spawners").get_children()
	$SpawnTimer.wait_time = 4
	$SpawnTimer.start()
