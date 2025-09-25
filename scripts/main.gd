extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_A:
			print("left")
			$RightArea.monitoring = false
			$LeftArea.monitoring = true
		if event.pressed and event.keycode == KEY_D:
			print("right")
			$RightArea.monitoring = true
			$LeftArea.monitoring = false
			
func body_entered(body:Node2D):
	print(body.name)
