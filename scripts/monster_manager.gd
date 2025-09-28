extends Node2D

var left_spawn: Vector2
var right_spawn: Vector2

@onready var monster_scene = preload("res://scenes/monster.tscn")

func spawn_monster():
	var new_monster = monster_scene.instantiate()
	var spawn_side = randi_range(1,2)
	var type = randf_range(0.0,1.0)
	
	left_spawn = Vector2((get_viewport_rect().size.x / 2) - 100, 200)
	right_spawn = Vector2( (get_viewport_rect().size.x / 2) + 100, 200)
		
	
	if type < 0.75:
		new_monster.type = new_monster.Type.MONSTER
	else:
		new_monster.type = new_monster.Type.ATTRACTION
		left_spawn.y -= 100
		right_spawn.y -= 100
	new_monster.set_sprite()
	if spawn_side == 1:
		new_monster.position = left_spawn
		new_monster.dir = -1
	else:
		new_monster.position = right_spawn
	
	add_child(new_monster)
		
