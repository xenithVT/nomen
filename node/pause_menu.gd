extends CanvasLayer

var game_paused = false
@onready var button_save = $MarginContainer/menu_options/MarginContainer/HBoxContainer/container_button/button_save
@onready var menu_options = $MarginContainer/menu_options
@onready var menu_stats = $MarginContainer/menu_stats
@onready var menu_items = $MarginContainer/menu_items
@onready var first_item = $MarginContainer/menu_items/MarginContainer/VBoxContainer/HBoxContainer/item_container_left/Button
@onready var label_hp = $MarginContainer/menu_options/MarginContainer/HBoxContainer/VBoxContainer2/label_character_health
@onready var player = get_parent()
@onready var audio_stream_player = player.get_node("audiostreamplayer_player")

var current_menu = "options"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_options.show()
	menu_stats.hide()
	menu_items.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel") and current_menu == "options" and game_paused:
		unpause()
	if Input.is_action_just_pressed("ui_cancel") and (current_menu == "stats" or current_menu == "items") and game_paused:
		menu_options.show()
		menu_stats.hide()
		menu_items.hide()
		button_save.grab_focus()
		current_menu = "options"
	if Input.is_action_just_pressed("pause_menu") and !game_paused:
		pause()
	elif Input.is_action_pressed("pause_menu") and game_paused:
		unpause()
		menu_options.show()
		menu_stats.hide()
		menu_items.hide()


func pause():
	label_hp.text = "hp: " + str(Playermanager.player_health)
	#label_sp.text = "sp: " + str(Playermanager.player_spirit)
	get_tree().paused = true
	self.visible = true
	button_save.grab_focus()
	game_paused = true
	menu_options.show()
	menu_stats.hide()
	menu_items.hide()


func unpause():
	get_tree().paused = false
	self.visible = false
	game_paused = false
	menu_options.show()
	menu_stats.hide()
	menu_items.hide()






# menu_options
func _on_button_save_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	#SaveLoad.save_game()
	#print_debug("game saved")
func _on_button_load_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	#SaveLoad.load_game()
	unpause()
func _on_button_stats_pressed() -> void:
	menu_options.hide()
	menu_stats.show()
	current_menu = "stats"
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
func _on_button_items_pressed() -> void:
	menu_options.hide()
	menu_items.show()
	current_menu = "items"
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	first_item.grab_focus()
func _on_button_quit_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	unpause()
	get_tree().change_scene_to_file("res://scene/menu_main.tscn")
