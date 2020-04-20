extends Control

onready var dead_tree_counter = $VBoxContainer/Up/DeadTrees/DeadTrees
onready var on_fire_trees_counter = $VBoxContainer/Up/TreesOFireContainer/TreesOnFire
onready var points_counter = $VBoxContainer/Bottom/Points
onready var difficulty_meter = $VBoxContainer/Bottom/Difficulty
var game_manager

func update_trees_on_fire(val):
	on_fire_trees_counter.set_text(str(val))

func update_dead_trees(val, lim):
	if  val > 0.8*lim:
		dead_tree_counter.add_color_override("font_color", Color(0.8,0.2,0.12))
	dead_tree_counter.set_text(str(val) + "/" + str(lim))

func update_points(val, diff):
	points_counter.set_text("Score: " + str(val))
	difficulty_meter.set_text("Level: " + str(diff+1))

func _on_WaterTimer_timeout():
	$VBoxContainer/Bottom/WateringBar.hide()

func update_water_bar(val, max_val):
	var water_bar = $VBoxContainer/Bottom/WateringBar
	water_bar.set_value(val)
	water_bar.set_max(max_val)
	if val == max_val:
		water_bar.tint_progress = Color(0,1,0)
	else:
		water_bar.tint_progress = Color(1,1,1)
	water_bar.show()
	$WaterTimer.start()

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_manager = get_parent().get_node("GameManager")
	if not game_manager:
		return
	
	game_manager.connect("trees_on_fire", self, "update_trees_on_fire")
	game_manager.connect("dead_trees", self, "update_dead_trees")
	game_manager.connect("updated_points", self, "update_points")

