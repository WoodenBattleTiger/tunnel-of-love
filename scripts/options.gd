extends TextureRect

func _on_resume_pressed():
	visible = false
	get_tree().paused = false

func _on_quit_pressed():
	get_tree().quit()


func _on_check_box_pressed() -> void:
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
