extends Node2D

@onready var combat_ui = $combat_ui
@onready var player = $player_combat

@onready var hitcircle = $hitcircle
@onready var audio_fight_music = $audio_fight_music
var rhythm_map_path: String
var rhythm_map_scene: PackedScene
var rhythm_map: Node2D
var rhythm_map_song
var rhythm_map_start = false
var current_rhythm_circle
var metronome_path
var bpm_timer
@onready var rhythm_hit_indicator_label = $combat_ui/Control/margin_fight_ui/VBoxContainer/label_hit_indicator
@onready var rhythm_hit_dmg_label = $combat_ui/Control/margin_fight_ui/VBoxContainer/label_hit_dmg
@onready var metronome_sound = preload("res://audio/combat/metronome.wav")

@onready var tilemap = $floor
@onready var tilemap_block = $tilemap_block

var player_current_position: Vector2 = Vector2(320, 97)
var player_default_position: Vector2 = Vector2(320, 97)
var tilemap_default_position: Vector2 = Vector2(10, -144)
var tilemap_hide_position: Vector2 = Vector2(-518, -144)
var player_hide_position: Vector2 = Vector2(320, 149)

var hitcircle_current_position: Vector2 = Vector2(320, -47)
var hitcircle_default_position: Vector2 = Vector2(320, 97)
var hitcircle_hide_position: Vector2 = Vector2(320, -47)

var rhythm_map_current_position: Vector2 = Vector2(640, 96)
var rhythm_map_spawn_position: Vector2 = Vector2(640, 96)
var rhythm_map_left_position: Vector2 = Vector2(-99999, 96)

var rhythm_great = false
var rhythm_good = false
var rhythm_bad = false
var rhythm_miss = true
var rhythm_dmg_total: int = 0
var rhythm_hit_counter: int = 0

var metronome_enabled


func _ready() -> void:
	metronome_enabled = Gamestate.metronome_enabled
	print("combat opponent is: ", Gamestate.combat_opponent)
	# get rhythm map and song
	rhythm_map_path = "res://node/rhythm_map/map_%s_fight.tscn" % Gamestate.combat_opponent
	rhythm_map_song = "res://audio/music/fight/fight_%s.wav" % Gamestate.combat_opponent
	find_valid_paths()
	rhythm_map_start = true
	#-
	Gamestate.combat_dodge_phase = true
	Gamestate.combat_choice_phase = false
	Gamestate.combat_fight_phase = false
	metronome_path.stream = metronome_sound
	start_metronome()
	player.position = player_hide_position


func find_valid_paths():
	if ResourceLoader.exists(rhythm_map_path):
		rhythm_map_scene = load(rhythm_map_path)
		print_debug("FOUND - rhythm map: ", rhythm_map_path)
		add_child(rhythm_map_scene.instantiate())
		rhythm_map = get_node("map_%s_fight" % Gamestate.combat_opponent)
		print(rhythm_map)
		metronome_path = get_node("map_%s_fight/metronome" % Gamestate.combat_opponent)
		bpm_timer = get_node("map_%s_fight/bpm_timer" % Gamestate.combat_opponent)
	else:
		push_error("ERR NOT FOUND - rhythm map or components: " + rhythm_map_path)
	if ResourceLoader.exists(rhythm_map_song):
		audio_fight_music.stream = load(rhythm_map_song)
		audio_fight_music.play()
		print_debug("FOUND - rhythm map song: ", rhythm_map_song)
	else:
		audio_fight_music.stream = load("res://audio/null.wav")
		push_error("ERR NOT FOUND - rhythm map song: " + rhythm_map_song)


func _unhandled_input(event: InputEvent) -> void:
	# combat phase switcher for debugging and testing
	if Input.is_action_just_pressed("pause_menu") and Gamestate.combat_dodge_phase:
		Gamestate.combat_choice_phase = true
		Gamestate.combat_dodge_phase = false
		Gamestate.combat_fight_phase = false
		print_debug("combat phase switch")

	elif Input.is_action_just_pressed("pause_menu") and !Gamestate.combat_dodge_phase:
		Gamestate.combat_choice_phase = false
		Gamestate.combat_dodge_phase = true
		Gamestate.combat_fight_phase = false
		print_debug("combat phase switch")

	if Gamestate.combat_fight_phase == true:
		get_hit_score()


# process
func _process(delta: float) -> void:
	player_current_position = player.position
	hitcircle_current_position = hitcircle.position
	rhythm_map_current_position = rhythm_map.position

	if Gamestate.combat_choice_phase == true:
		pass
	if Gamestate.combat_fight_phase == false:
		rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("ffffffff"))
		rhythm_hit_indicator_label.text = ""
	if Gamestate.combat_dodge_phase == true:
		pass


var player_moved = false
func _physics_process(delta: float) -> void:
	var t: float = 0.0
	t += delta * 5
	var t2: float = 0.0
	t2 = delta * 250
	if rhythm_map_start:
		rhythm_map.position = rhythm_map_current_position.move_toward(rhythm_map_left_position, t2)
	if Gamestate.combat_choice_phase == true:
		Gamestate.player_can_move = false
		player.hide()
		rhythm_map.hide()
		player_moved = false
		player.position = player_hide_position
		tilemap.position = tilemap_hide_position
		hitcircle.position = hitcircle_current_position.lerp(hitcircle_hide_position, t)

	elif Gamestate.combat_dodge_phase == true:
		player.show()
		rhythm_map.hide()
		tilemap.position = tilemap_default_position
		hitcircle.position = hitcircle_hide_position
		if !player_moved:
			player.position = player_current_position.lerp(player_default_position, t)
			if player.position.distance_to(player_default_position) < 1.0:
				player_moved = true
				Gamestate.player_can_move = true

	elif Gamestate.combat_fight_phase == true:
		Gamestate.player_can_move = false
		player.hide()
		rhythm_map.show()
		player_moved = false
		player.position = player_hide_position
		tilemap.position = tilemap_hide_position
		hitcircle.position = hitcircle_current_position.lerp(hitcircle_default_position, t)

	if rhythm_hit_counter == 5:
		Gamestate.combat_dodge_phase = true


func start_metronome() -> void:
	while metronome_enabled and Gamestate.combat_fight_phase:
		metronome_path.play()
		bpm_timer.start()
		await bpm_timer.timeout
		if !metronome_enabled and !Gamestate.combat_fight_phase:
			break


# determine score awarded
func get_hit_score():
	if Input.is_action_just_pressed("ui_cancel") and rhythm_great == true:
		rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("6fb7ab"))
		rhythm_hit_indicator_label.text = "perfect!"

		rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("6fb7ab"))
		rhythm_dmg_total += Gamestate.player_damage
		rhythm_hit_dmg_label.text = str(rhythm_dmg_total)
		rhythm_hit_counter += 1

		#await get_tree().create_timer(0.8).timeout
		#rhythm_hit_indicator_label.text = ""
		current_rhythm_circle.play("hit")

	if Input.is_action_just_pressed("ui_cancel") and rhythm_good == true:
		rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("afc168"))
		rhythm_hit_indicator_label.text = "good!"

		rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("afc168"))
		rhythm_dmg_total += Gamestate.player_damage / 2
		rhythm_hit_dmg_label.text = str(rhythm_dmg_total)
		#await get_tree().create_timer(0.8).timeout
		rhythm_hit_counter += 1
		#rhythm_hit_indicator_label.text = ""
		current_rhythm_circle.play("hit")

	if Input.is_action_just_pressed("ui_cancel") and rhythm_bad == true:
		rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("cdb75f"))
		rhythm_hit_indicator_label.text = "bad..."

		rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("cdb75f"))
		rhythm_dmg_total += Gamestate.player_damage / 8
		rhythm_hit_dmg_label.text = str(rhythm_dmg_total)
		#await get_tree().create_timer(0.8).timeout
		rhythm_hit_counter += 1
		#rhythm_hit_indicator_label.text = ""
		current_rhythm_circle.play("hit")

	if Input.is_action_just_pressed("ui_cancel") and rhythm_miss == true:
		rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("764559"))
		rhythm_hit_indicator_label.text = "miss."

		rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("764559"))
		rhythm_dmg_total -= Gamestate.player_damage / 8
		rhythm_hit_dmg_label.text = str(rhythm_dmg_total)
		#await get_tree().create_timer(0.8).timeout
		rhythm_hit_counter += 1
		#rhythm_hit_indicator_label.text = ""
		#current_rhythm_circle.play("miss")







# determine hit timing
func _on_great_area_entered(area: Area2D) -> void:
	if area.is_in_group("rhythm_circle"):
		rhythm_great = true
		rhythm_good = false
		rhythm_bad = false
		rhythm_miss = false
func _on_great_area_exited(area: Area2D) -> void:
	if area.is_in_group("rhythm_circle"):
		rhythm_great = false
		rhythm_miss = false
func _on_good_area_entered(area: Area2D) -> void:
	if area.is_in_group("rhythm_circle"):
		rhythm_good = true
		rhythm_bad = false
		rhythm_miss = false
func _on_good_area_exited(area: Area2D) -> void:
	if area.is_in_group("rhythm_circle"):
		rhythm_good = false
		rhythm_miss = false
func _on_bad_area_entered(area: Area2D) -> void:
	if area.is_in_group("rhythm_circle"):
		print(current_rhythm_circle)
		current_rhythm_circle = area.get_child(1)
		rhythm_bad = true
		rhythm_miss = false
	if area.is_in_group("miss_window"):
		current_rhythm_circle = area.get_child(1)
		rhythm_miss = true
func _on_bad_area_exited(area: Area2D) -> void:
	if area.is_in_group("rhythm_circle"):
		print(current_rhythm_circle)
		current_rhythm_circle = area.get_child(1)
		rhythm_bad = false
		rhythm_miss = true
	if area.is_in_group("miss_window"):
		rhythm_miss = false
