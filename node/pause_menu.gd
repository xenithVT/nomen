extends CanvasLayer

var game_paused = false
@onready var button_save = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/container_button/button_save
@onready var player = get_parent()
@onready var audio_stream_player = player.get_node("audiostreamplayer_player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event):
	if Input.is_action_just_pressed("pause_menu") and !game_paused:
		pause()
	elif Input.is_action_pressed("pause_menu") and game_paused:
		unpause()


func pause():
	get_tree().paused = true
	self.visible = true
	button_save.grab_focus()
	game_paused = true


func unpause():
	get_tree().paused = false
	self.visible = false
	game_paused = false


func _on_button_save_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	#SaveLoad.save_game()
	#print_debug("game saved")


func _on_button_load_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	#SaveLoad.load_game()
	unpause()


func _on_button_stats_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout


func _on_button_items_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout


func _on_button_quit_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	unpause()
	get_tree().change_scene_to_file("res://scene/menu_main.tscn")
