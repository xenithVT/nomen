extends Node2D

var audio_stream_player: AudioStreamPlayer
@onready var anim_transition = $canvas_transitions


func _ready() -> void:
	anim_transition.no_transition()
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
	anim_transition.fade_out()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scene/menu_choose_name.tscn")


func _on_load_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout


func _on_options_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout


func _on_quit_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
