extends MarginContainer

const msg1 = "You scored "
const msg2 = " points. Congratulations.\nYour record is "
const msg3 = " points."

onready var msgLabel = $CenterContainer/VBoxContainer/Label

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	msgLabel.set_text(msg1 + str(GameData.curr_score) + msg2 + str(GameData.best_score) + msg3)
	GlobalAudioManager.get_node("MenuMusic").play()
