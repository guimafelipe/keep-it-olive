extends Control

onready var dead_tree_counter = $VBoxContainer/Up/DeadTrees
onready var on_fire_trees_counter = $VBoxContainer/Up/TreesOnFire
var game_manager

func update_trees_on_fire(val):
	on_fire_trees_counter.set_text(str(val))

func update_dead_trees(val, lim):
	dead_tree_counter.set_text(str(val) + "/" + str(lim))

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_manager = get_parent().get_node("GameManager")
	if not game_manager:
		return
	
	game_manager.connect("trees_on_fire", self, "update_trees_on_fire")
	game_manager.connect("dead_trees", self, "update_dead_trees")
