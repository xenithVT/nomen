extends CanvasLayer

var game_paused = false
@onready var button_save = $MarginContainer/menu_options/MarginContainer/HBoxContainer/container_button/button_save
@onready var button_load = $MarginContainer/menu_options/MarginContainer/HBoxContainer/container_button/button_load
@onready var button_stats = $MarginContainer/menu_options/MarginContainer/HBoxContainer/container_button/button_stats
@onready var button_items = $MarginContainer/menu_options/MarginContainer/HBoxContainer/container_button/button_items
@onready var button_quit = $MarginContainer/menu_options/MarginContainer/HBoxContainer/container_button/button_quit
@onready var menu_options = $MarginContainer/menu_options
@onready var label_hp_options = $MarginContainer/menu_options/MarginContainer/HBoxContainer/VBoxContainer2/label_character_health
@onready var label_xp_options = $MarginContainer/menu_options/MarginContainer/HBoxContainer/VBoxContainer2/label_character_lvl
@onready var menu_stats = $MarginContainer/menu_stats
@onready var menu_items = $MarginContainer/menu_items
@onready var first_item = $MarginContainer/menu_items/MarginContainer/VBoxContainer/HBoxContainer/item_container_left/Button
@onready var player = get_parent()
@onready var audio_stream_player = player.get_node("audiostreamplayer_player")

@onready var label_name_options = $MarginContainer/menu_options/MarginContainer/HBoxContainer/VBoxContainer2/label_character_name
@onready var label_name = $MarginContainer/menu_stats/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/label_character_name
@onready var label_hp = $MarginContainer/menu_stats/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/label_character_health
@onready var label_lvl = $MarginContainer/menu_stats/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/label_character_lvl
@onready var label_sp = $MarginContainer/menu_stats/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/label_character_spirit
@onready var label_xp = $MarginContainer/menu_stats/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/label_character_xp
@onready var label_def = $MarginContainer/menu_stats/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/label_character_def

var last_button_pressed
var really_quit = false

var current_menu = "options"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_name_options.text = str(Playermanager.player_name)
	menu_options.show()
	menu_stats.hide()
	menu_items.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label_hp_options.text = "hp: " + str(Playermanager.player_health) + "/" + str(Playermanager.player_max_health)
	label_xp_options.text = "xp: " + str(Playermanager.player_xp) + "/" + str(Playermanager.player_xp_for_next_lvl)


func _unhandled_input(event):
	if Input.is_action_just_pressed("player_cancel") and current_menu == "options" and game_paused:
		unpause()
		button_quit.text = "quit"
		really_quit = false
	if Input.is_action_just_pressed("player_cancel") and (current_menu == "stats" or current_menu == "items") and game_paused:
		menu_options.show()
		menu_stats.hide()
		menu_items.hide()
		last_button_pressed.grab_focus()
		current_menu = "options"
		button_quit.text = "quit"
		really_quit = false
	if Input.is_action_just_pressed("pause_menu") and !game_paused:
		pause()
		button_quit.text = "quit"
		really_quit = false
	elif Input.is_action_pressed("pause_menu") and game_paused:
		unpause()
		menu_options.show()
		menu_stats.hide()
		menu_items.hide()
		button_quit.text = "quit"
		really_quit = false


func refresh_stats():
	label_name.text = str(Playermanager.player_name)
	label_lvl.text = "lvl: " + str(Playermanager.player_lvl)
	label_hp.text = "hp: " + str(Playermanager.player_health)
	label_sp.text = "sp: " + str(Playermanager.player_spirit)
	label_def.text = "def: " + str(Playermanager.player_defense)
	label_xp.text = "xp: " + str(Playermanager.player_xp)


func pause():
	label_hp_options.text = "hp: " + str(Playermanager.player_health)
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
	last_button_pressed = button_save
	#SaveLoad.save_game()
	#print_debug("game saved")
func _on_button_load_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select_invalid.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	#SaveLoad.load_game()
	#unpause()
	last_button_pressed = button_load
func _on_button_stats_pressed() -> void:
	refresh_stats()
	menu_options.hide()
	menu_stats.show()
	current_menu = "stats"
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	last_button_pressed = button_stats
func _on_button_items_pressed() -> void:
	menu_options.hide()
	menu_items.show()
	current_menu = "items"
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	first_item.grab_focus()
	last_button_pressed = button_items
func _on_button_quit_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	button_quit.text = "rlly?"
	await get_tree().create_timer(0.1).timeout
	if really_quit:
		unpause()
		get_tree().change_scene_to_file("res://scene/menu_main.tscn")
	really_quit = true
