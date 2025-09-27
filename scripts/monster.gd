extends CharacterBody2D

class_name Monster

enum Type {MONSTER, ATTRACTION}

var monster_textures = [preload("res://sprites/placeholders/placeholders/enemy_angler.png"),
preload("res://sprites/placeholders/placeholders/enemy_bear_1.png"),
preload("res://sprites/placeholders/placeholders/enemy_bear_2.png"),
preload("res://sprites/placeholders/placeholders/enemy_bear_3.png"),
preload("res://sprites/placeholders/placeholders/enemy_rose.png")]

var attraction_textures = [preload("res://sprites/placeholders/placeholders/distraction_balloon.png"),
preload("res://sprites/placeholders/placeholders/distraction_hearts.png"),
preload("res://sprites/placeholders/placeholders/distraction_raccoon.png"),
preload("res://sprites/placeholders/placeholders/distraction_swing.png")]

@export var type: Type
var collected = false

var dir = 1

func _ready() -> void:
	if type == Type.ATTRACTION:
		$ColorRect.color = Color.RED

func _process(_delta: float) -> void:
	
	if dir == 1:
		$Sprite2D.flip_h = true
	
	scale.x = (1.0 * (position.y / get_viewport_rect().size.y))
	scale.y = (1.0 * (position.y / get_viewport_rect().size.y))
	
	velocity.y = 250
	velocity.x = 95 * dir
	
	move_and_slide()
	
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()
		
func set_sprite():
	if type == Type.MONSTER:
		var rand_idx = randi_range(0, monster_textures.size() - 1)
		$Sprite2D.texture = monster_textures[rand_idx]
	else:
		var rand_idx = randi_range(0, attraction_textures.size() - 1)
		$Sprite2D.texture = attraction_textures[rand_idx]
