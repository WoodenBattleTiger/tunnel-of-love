extends Node2D

var left_spawn = Vector2(288, -10)
var right_spawn = Vector2(864, -10)

@onready var monster_scene = preload("res://scenes/monster.tscn")

func spawn_monster():
	var new_monster = monster_scene.instantiate()
	var spawn_side = randi_range(1,2)
	if spawn_side == 1:
		new_monster.position = left_spawn
	else:
		new_monster.position = right_spawn
	
	add_child(new_monster)
		
