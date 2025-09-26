extends CharacterBody2D

enum Type {MONSTER, ATTRACTION}

@export var type: Type
var collected = false

var dir = 1

func _ready() -> void:
	if type == Type.ATTRACTION:
		$ColorRect.color = Color.RED

func _process(_delta: float) -> void:
	
	scale.x = (1.0 * (position.y / get_viewport_rect().size.y)) + 0.5
	scale.y = (1.0 * (position.y / get_viewport_rect().size.y)) + 0.5
	
	velocity.y = 250
	velocity.x = 50 * dir
	
	move_and_slide()
	
	if position.y > 650:
		queue_free()
