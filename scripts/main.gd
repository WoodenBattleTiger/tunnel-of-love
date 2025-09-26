extends Node2D

var patience = 100.0
var patience_timer: SceneTreeTimer

func _ready() -> void:
	patience_timer = get_tree().create_timer(1)
	patience_timer.connect("timeout", on_patience_timer_timeout)
	$Patience.value = patience
	
func on_patience_timer_timeout():
	patience -= 0.5
	#print(patience)
	$Patience.value = patience
	patience_timer = get_tree().create_timer(1)
	patience_timer.connect("timeout", on_patience_timer_timeout)

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
	patience -= 15
	$Patience.value = patience
	
