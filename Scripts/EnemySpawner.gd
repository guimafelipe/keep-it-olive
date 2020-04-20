extends Position3D

var enemy_class = preload("res://Scenes/Enemy.tscn")

func spawn_enemy():
	var new_enemy = enemy_class.instance()
	new_enemy.global_transform = self.global_transform
	new_enemy.translate(Vector3(0,1.5,0))
	get_tree().root.get_node("Main").add_child(new_enemy)
	new_enemy.init()

func _ready():
	pass
