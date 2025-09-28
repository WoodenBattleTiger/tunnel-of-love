extends Control
	
func _ready() -> void:
	get_tree().paused = false

func _on_start_pressed() -> void:
	$SFXPlayer.play()
	get_tree().root.add_child(load("res://scenes/main.tscn").instantiate())
	$AudioStreamPlayer.stop()
	get_tree().root.remove_child(self)


func _on_resume_pressed() -> void:
	$SFXPlayer.play()
	$Options.visible = false

func _on_quit_pressed() -> void:
	print("???")
	$SFXPlayer.play()
	get_tree().quit()

func _on_settings_pressed() -> void:
	$SFXPlayer.play()
	$Options.visible = true


func _on_check_box_pressed() -> void:
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
