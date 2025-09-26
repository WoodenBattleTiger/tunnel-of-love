extends CharacterBody2D

enum Type {MONSTER, ATTRACTION}

@export var type: Type
var collected = false

func _ready() -> void:
	if type == Type.ATTRACTION:
		$ColorRect.color = Color.RED

func _process(_delta: float) -> void:
	
	velocity.y = 250
	
	move_and_slide()
	
	if position.y > 650:
		queue_free()
