extends Node2D

@export var monster_patience_penalty = 15

@export var distraction_patience_bonus = 15
@export var distraction_collect_bonus = 2

@export var patience_decay_rate = 0.5

@export var phase_length = 1 #number of loops
var phase = 1
var current_loop = 1

@onready var r: RhythmNotifier = $RhythmNotifier 

var swan_left = preload("res://sprites/placeholders/placeholders/boat_aim_left.png")
var swan_left_shoot = preload("res://sprites/placeholders/placeholders/boat_shoot_left.png")
var swan_right = preload("res://sprites/placeholders/placeholders/boat_aim_right.png")
var swan_right_shoot = preload("res://sprites/placeholders/placeholders/boat_shoot_right.png")

var patience = 65.0
var patience_timer: SceneTreeTimer

var score = 0
var combo = 1

var face_right = true

func _ready() -> void:
	$PatienceTimer.connect("timeout", on_patience_timer_timeout)
	%Patience.value = patience
	
	var resource = load("res://dialogue/test.dialogue")
	get_tree().paused = true
	await DialogueManager.show_dialogue_balloon(resource, "start").tree_exited
	get_tree().paused = false
	$AudioStreamPlayer.play(0.0)
	
	r.beats(4).connect(func(count): if count != 0: $MonsterManager.spawn_monster())
	
func on_patience_timer_timeout():
	update_patience(patience_decay_rate * -1)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_SPACE:
			print("flip")
			if face_right:
				$Level/Char_Player.texture = load("res://sprites/placeholders/placeholders/chara_player_point_left.png")
				$Level/Char_Date.texture = load("res://sprites/placeholders/placeholders/chara_date_photo_left.png")
			else:
				$Level/Char_Player.texture = load("res://sprites/placeholders/placeholders/chara_player_point_right.png")
				$Level/Char_Date.texture = load("res://sprites/placeholders/placeholders/chara_date.png")
			face_right = !face_right
			#$Level/Char_Date.scale.x *= -1
			$RightArea.monitoring = !$RightArea.monitoring
			$LeftArea.monitoring = !$LeftArea.monitoring
			$LeftArea/CollisionShape2D/ColorRect.visible = !$LeftArea/CollisionShape2D/ColorRect.visible
			$RightArea/CollisionShape2D/ColorRect.visible = !$RightArea/CollisionShape2D/ColorRect.visible
			await get_tree().create_timer(1.5).timeout
			$Level/Char_Player.texture = load("res://sprites/placeholders/placeholders/chara_player.png")
			
		if event.pressed and event.keycode == KEY_ESCAPE:
			$UI/Options.visible = true
			get_tree().paused = true
	if event.is_action_pressed("shoot") && $ShootTimer.is_stopped():
		if get_viewport().get_mouse_position().x > get_viewport_rect().size.x / 2:
			spawn_arrow(1)
			print("shoot right")
			$Level/Swan_Head.texture = swan_right_shoot
		else:
			spawn_arrow(-1)
			print("shoot left")
			$Level/Swan_Head.texture = swan_left_shoot
		$SFXPlayer.play()
			
func spawn_arrow(dir):
	var new_arrow = load("res://scenes/arrow.tscn").instantiate()
	new_arrow.dir = dir
	new_arrow.position.x = get_viewport_rect().size.x / 2
	new_arrow.position.y = get_viewport_rect().size.y / 2
	new_arrow.connect("update_combo", update_combo)
	new_arrow.connect("clear_combo", clear_combo)
	$BulletManager.add_child(new_arrow)
	$ShootTimer.start()
	
func _process(_delta: float) -> void:
	if get_viewport().get_mouse_position().x > get_viewport_rect().size.x / 2 && $ShootTimer.is_stopped():
		#print("shoot right")
		$Level/Swan_Head.texture = swan_right
	elif $ShootTimer.is_stopped():
		$Level/Swan_Head.texture = swan_left
		#print("shoot left")
	
func body_entered(body:Node2D):
	#print(body.name)
	if body is Monster:
		if !body.collected:
			if body.type == body.Type.MONSTER:
				update_patience(-1 * monster_patience_penalty)
				body.collected = true
				if face_right:
					$Level/Char_Date.texture = load("res://sprites/placeholders/placeholders/chara_date_shock_right.png")
					await get_tree().create_timer(1.0, false).timeout
					$Level/Char_Date.texture = load("res://sprites/placeholders/placeholders/chara_date.png")
				else:
					$Level/Char_Date.texture = load("res://sprites/placeholders/placeholders/chara_date_shock_left.png")
					await get_tree().create_timer(1.0, false).timeout
					$Level/Char_Date.texture = load("res://sprites/placeholders/placeholders/chara_date_photo_left.png")
				
			else:
				update_patience(distraction_patience_bonus)
				update_score(distraction_collect_bonus)
				body.collected = true
	
func update_patience(val):
	patience += val
	if patience > 100:
		patience = 100
		
	if patience < 53:
		$UI/Patience/DateIcon.texture = load("res://sprites/Patience Meter/Icon Angry.png")
	elif patience < 74:
		$UI/Patience/DateIcon.texture = load("res://sprites/Patience Meter/Icon Neutral.png")
	else:
		$UI/Patience/DateIcon.texture = load("res://sprites/Patience Meter/Icon Happy.png")
	
	if patience <= 37:
		patience = 0
		print("game over!")
		game_over()
	
	%Patience.value = patience
	
func update_combo(val):
	combo += val
	%Combo.text = str(combo)
	
func clear_combo():
	combo = 1
	%Combo.text = str(combo)
	
func update_score(val):
	score += val * combo
	%Score.text = str(score) + " pts"
	
func game_over():
	$GameOver.visible = true
	get_tree().paused = true
	
func restart():
	$GameOver.visible = false
	get_tree().paused = false
	clear_combo()
	score = 0
	phase = 1
	current_loop = 1
	%Score.text = "Score: " + str(score)
	patience = 100
	$AudioStreamPlayer.play(0.0)
	for child in $MonsterManager.get_children():
		child.queue_free()
	#TODO: need to restart dialogue


func _on_audio_stream_player_finished() -> void:
	#check for next phase
	if current_loop == phase_length:
		print("phase over")
		phase += 1
		#$TransitionPlayer.play()
		#await $TransitionPlayer.finished
	
		if phase == 2:
			current_loop = 1
			$AudioStreamPlayer.stream = load("res://audio/track2_130_final.wav")
			$RhythmNotifier.bpm = 130
			$AudioStreamPlayer.play()
			$ShootTimer.wait_time = $RhythmNotifier.beat_length
		
		if phase == 3:
			current_loop = 1
			$AudioStreamPlayer.stream = load("res://audio/track3_140_verfinal.wav")
			$RhythmNotifier.bpm = 140
			$AudioStreamPlayer.play()
			$ShootTimer.wait_time = $RhythmNotifier.beat_length
	
	else:
		current_loop += 1
		$AudioStreamPlayer.play()
