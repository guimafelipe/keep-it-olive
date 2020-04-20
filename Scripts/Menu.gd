extends Control

func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")
	GlobalAudioManager.get_node("MenuMusic").stop()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if not GlobalAudioManager.get_node("MenuMusic").playing:
		GlobalAudioManager.get_node("MenuMusic").play()
	
