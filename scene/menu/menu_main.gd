extends Node2D

var audio_stream_player: AudioStreamPlayer
@onready var anim_transition = $canvas_transitions
@onready var http_request = $HTTPRequest
@onready var label_version = $label_version
@onready var update_label = $Control/update_label
var up_to_date = true


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != OK or response_code != 200:
		print("Request failed or file not found")
		return

	var remote_version = body.get_string_from_utf8().strip_edges()
	print("Remote version:", remote_version)

	var local_version = Gamestate.game_version
	if remote_version != local_version:
		print("Update available!")
		up_to_date = false
		update_label.show()
	else:
		print("Game is up to date.")
		up_to_date = true
		update_label.hide()


func check_for_update():
	var url = "https://raw.githubusercontent.com/xen-nomen/nomen/main/version.txt"
	http_request.connect("request_completed", Callable(http_request, "_on_request_completed"))
	var err = http_request.request(url)
	if err != OK:
		print_debug("Failed to make HTTP request:", err)


func _ready() -> void:
	label_version.text = "v" + Gamestate.game_version
	check_for_update()
	update_label.hide()
	$HTTPRequest.request("https://github.com/xenithVT/nomen/tree/main")
	audio_stream_player = $AudioStreamPlayer
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	DisplayServer.warp_mouse(Vector2(-1000, -1000))
	for button in get_tree().get_nodes_in_group("container_button"):
		button.focus_mode = Control.FOCUS_BEHAVIOR_DISABLED
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$MarginContainer2/VBoxContainer/start.grab_focus()
	anim_transition.fade_in()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	anim_transition.fade_out()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scene/menu/menu_choose_name.tscn")


func _on_load_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.3).timeout


func _on_options_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.3).timeout


func _on_quit_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()
