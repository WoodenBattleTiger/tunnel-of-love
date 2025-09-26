extends CharacterBody2D

func _process(_delta: float) -> void:
	
	velocity.y = 100
	
	move_and_slide()
	
	if position.y > 650:
		queue_free()
