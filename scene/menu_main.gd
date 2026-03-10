extends Node2D

var audio_stream_player: AudioStreamPlayer


func _ready() -> void:
	audio_stream_player = $AudioStreamPlayer
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	DisplayServer.warp_mouse(Vector2(-1000, -1000))
	for button in get_tree().get_nodes_in_group("container_button"):
		button.focus_mode = Control.FOCUS_BEHAVIOR_DISABLED
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$MarginContainer2/VBoxContainer/start.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scene/level_cave_01.tscn")


func _on_load_pressed() -> void:
	pass  # Replace with function body.


func _on_options_pressed() -> void:
	pass  # Replace with function body.


func _on_quit_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
