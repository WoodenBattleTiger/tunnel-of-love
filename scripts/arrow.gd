extends Node2D

var dir = 1
@export var speed = 15

signal update_combo
signal clear_combo

func _physics_process(_delta: float) -> void:
	
	position.x += speed * dir


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Monster:
		body.queue_free()
		queue_free()
		if body.type == body.Type.MONSTER:
			update_combo.emit(1)
		else:
			clear_combo.emit()
