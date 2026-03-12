extends Node2D

@onready var anim_transition = $canvas_transitions
@onready var name_line = $CanvasLayer/MarginContainer/MarginContainer/Panel/MarginContainer/LineEdit
@onready var button_no = $CanvasLayer/MarginContainer/MarginContainer2/Control/container_button/button_no
@onready var container_button = $CanvasLayer/MarginContainer/MarginContainer2/Control/container_button
@onready var audio_stream_player = $AudioStreamPlayer

var dialogue_file = preload("res://script/dialogue/menu_choose_name.dialogue")
@onready var dialogue_balloon = $CanvasLayer/MarginContainer/MarginContainer2/Control/container_button/dialogue_balloon_menu

var name_text: String = ""
var is_name_okay = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	anim_transition.fade_in()
	name_line.grab_focus()
	DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, dialogue_file, "start")
	container_button.hide()


func _process(delta: float) -> void:
	pass


func _on_line_edit_text_submitted(new_text: String) -> void:
	name_text = new_text
	name_check()
	print_debug(is_name_okay)
	if is_name_okay:
		print_debug(name_text)
		audio_stream_player.stream = load("res://audio/menu/select.wav")
		audio_stream_player.play()
		await get_tree().create_timer(0.1).timeout
		container_button.show()
		button_no.grab_focus()
	elif !is_name_okay:
		print_debug(name_text)
		audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
		audio_stream_player.play()
		container_button.hide()
		await get_tree().process_frame
		button_no.grab_focus()
		await get_tree().create_timer(0.1).timeout
		name_line.grab_focus()


func _on_button_no_button_down() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	name_line.grab_focus()


func _on_button_yes_button_down() -> void:
	if is_name_okay:
		Playermanager.player_name = name_text
		print_debug(Playermanager.player_name)
		audio_stream_player.stream = load("res://audio/menu/select.wav")
		audio_stream_player.play()
		$canvas_transitions.fade_out()
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://scene/level_cave_00.tscn")
	else:
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, dialogue_file, "change your name")
		audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
		audio_stream_player.play()


func name_check():
	var name_check = name_text.strip_edges().to_lower()
	if name_check == "sans":
		is_name_okay = false
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, dialogue_file, "sans")
	elif name_check == "papyrus":
		is_name_okay = true
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, dialogue_file, "papyrus")
	elif name_check == "":
		is_name_okay = false
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, dialogue_file, "empty")
	elif name_check == "anima":
		is_name_okay = true
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, dialogue_file, "anima")
	else:
		is_name_okay = true
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, dialogue_file, "sure")


func _on_line_edit_text_changed(new_text: String) -> void:
	var regex := RegEx.new()
	regex.compile("[^A-Za-z]")  # anything NOT A-Z

	var cleaned = regex.sub(new_text, "", true)

	if cleaned != new_text:
		name_line.text = cleaned
		name_line.caret_column = cleaned.length()
