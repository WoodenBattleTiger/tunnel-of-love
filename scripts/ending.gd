extends Control

var current_slide = 1


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("flip") && visible:
		current_slide += 1
		if current_slide < 6:
			$TextureRect.texture = load("res://sprites/Ending/" + str(current_slide) + ".png")
		else:
			get_tree().root.add_child(load("res://scenes/start_menu.tscn").instantiate())
			get_tree().root.remove_child(get_parent())


func _on_visibility_changed() -> void:
	if visible:
		get_parent().get_node("GameOverMusic").stream = load("res://audio/titletrack_ver2.wav")
		get_parent().get_node("GameOverMusic").play()
