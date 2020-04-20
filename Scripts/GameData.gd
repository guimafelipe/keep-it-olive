extends Node

const max_difficulty = 7
const max_burnt_trees = 2

const difficulty_map = [0.0, 20.0, 40.0, 60.0, 80.0, 120.0, 160.0, 180.0]

const interval_time = [10.0, 9.0, 8.0, 7.0, 6.0, 4.0, 2.0, 1.0]

const first_spawn_time = 4.0

var lost_state = 0

var best_score = 0
var curr_score = 0

func save():
	var bs = best_score
	var save_game = File.new()
	save_game.open("user://game_data.save", File.WRITE)
	var save_dict = {
		"tuturu":  bs,
	}
	save_game.store_line(to_json(save_dict))

func load_game():
	var save_game = File.new()
	if(not save_game.file_exists("user://game_data.save")):
		return
	save_game.open("user://game_data.save", File.READ)
	var info = parse_json(save_game.get_line())
	best_score = info["tuturu"]
	save_game.close()

func update_record():
	best_score = max(best_score, curr_score)
	save()

func _on_Points_Updated(points, _dif):
	curr_score = points

func _ready():
	load_game()
