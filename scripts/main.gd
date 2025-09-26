extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_A:
			print("left")
			$RightArea.monitoring = false
			$LeftArea.monitoring = true
			$LeftArea/ColorRect.visible = true
			$RightArea/ColorRect.visible = false
		if event.pressed and event.keycode == KEY_D:
			print("right")
			$RightArea.monitoring = true
			$LeftArea.monitoring = false
			$LeftArea/ColorRect.visible = false
			$RightArea/ColorRect.visible = true
		if event.pressed and event.keycode == KEY_SPACE:
			$MonsterManager.spawn_monster()
			
func body_entered(body:Node2D):
	print(body.name)
