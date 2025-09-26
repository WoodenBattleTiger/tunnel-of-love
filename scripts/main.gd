extends Node2D

@onready var r: RhythmNotifier = $RhythmNotifier 

var patience = 100.0
var patience_timer: SceneTreeTimer

func _ready() -> void:
	patience_timer = get_tree().create_timer(1)
	patience_timer.connect("timeout", on_patience_timer_timeout)
	$Patience.value = patience
	r.beats(4).connect(func(count): if count != 0: $MonsterManager.spawn_monster())
	
func on_patience_timer_timeout():
	update_patience(-0.5)
	patience_timer = get_tree().create_timer(1)
	patience_timer.connect("timeout", on_patience_timer_timeout)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_A:
			print("left")
			$RightArea.monitoring = false
			$LeftArea.monitoring = true
			$LeftArea/CollisionShape2D/ColorRect.visible = true
			$RightArea/CollisionShape2D/ColorRect.visible = false
		if event.pressed and event.keycode == KEY_D:
			print("right")
			$RightArea.monitoring = true
			$LeftArea.monitoring = false
			$LeftArea/CollisionShape2D/ColorRect.visible = false
			$RightArea/CollisionShape2D/ColorRect.visible = true
		if event.pressed and event.keycode == KEY_SPACE:
			$MonsterManager.spawn_monster()
			
func body_entered(body:Node2D):
	print(body.name)
	if !body.collected:
		if body.type == body.Type.MONSTER:
			update_patience(-15)
			body.collected = true
		else:
			update_patience(15)
			body.collected = true
	
func update_patience(val):
	patience += val
	if patience > 100:
		patience = 100
	
	if patience <= 0:
		patience = 0
		print("game over!")
	
	$Patience.value = patience
	
