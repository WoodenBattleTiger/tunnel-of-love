extends Control
	

func _on_start_pressed() -> void:
	get_tree().root.add_child(load("res://scenes/main.tscn").instantiate())
	$AudioStreamPlayer.stop()


func _on_resume_pressed() -> void:
	$Options.visible = false

func _on_quit_pressed() -> void:
	print("???")
	get_tree().quit()

func _on_settings_pressed() -> void:
	$Options.visible = true
