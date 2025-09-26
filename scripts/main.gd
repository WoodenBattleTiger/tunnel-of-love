extends Node2D

@onready var r: RhythmNotifier = $RhythmNotifier 

var patience = 100.0
var patience_timer: SceneTreeTimer

func _ready() -> void:
	patience_timer = get_tree().create_timer(1)
	patience_timer.connect("timeout", on_patience_timer_timeout)
	$Patience.value = patience
	r.beats(4).connect(func(count): if count != 0: $MonsterManager.spawn_monster())
	var resource = load("res://dialogue/test.dialogue")
	# then
	get_tree().paused = true
	await DialogueManager.show_dialogue_balloon(resource, "start").tree_exited
	get_tree().paused = false
	
func on_patience_timer_timeout():
	update_patience(-0.5)
	patience_timer = get_tree().create_timer(1)
	patience_timer.connect("timeout", on_patience_timer_timeout)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			print("flip")
			$RightArea.monitoring = !$RightArea.monitoring
			$LeftArea.monitoring = !$LeftArea.monitoring
			$LeftArea/CollisionShape2D/ColorRect.visible = !$LeftArea/CollisionShape2D/ColorRect.visible
			$RightArea/CollisionShape2D/ColorRect.visible = !$RightArea/CollisionShape2D/ColorRect.visible
	if event.is_action_pressed("shoot"):
		if get_viewport().get_mouse_position().x > get_viewport_rect().size.x / 2:
			spawn_arrow(1)
			print("shoot right")
		else:
			spawn_arrow(-1)
			print("shoot left")
			
func spawn_arrow(dir):
	var new_arrow = load("res://scenes/arrow.tscn").instantiate()
	new_arrow.dir = dir
	new_arrow.position.x = get_viewport_rect().size.x / 2
	new_arrow.position.y = get_viewport_rect().size.y / 2
	add_child(new_arrow)
	
func body_entered(body:Node2D):
	print(body.name)
	if body is Monster:
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
	
