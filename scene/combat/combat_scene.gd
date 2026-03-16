extends Node2D

@onready var combat_ui = $combat_ui
@onready var player = $player_combat

@onready var hitcircle = $hitcircle
@onready var audio_fight_music = $audio_fight_music
@onready var audio_fight_sfx = $audio_fight_sfx

var opponent = Gamestate.combat_opponent

var rhythm_chart = []
var rhythm_chart_index = 0
var rhythm_spawn_ahead = 2.0

var rhythm_map_song
var current_rhythm_circle
var bpm

@onready var anim_hitcircle = $anim_hitcircle
@onready var rhythm_hit_indicator_label = $combat_ui/Control/margin_fight_ui/VBoxContainer/label_hit_indicator
@onready var rhythm_hit_dmg_label = $combat_ui/Control/margin_fight_ui/VBoxContainer/label_hit_dmg
@onready var rhythm_note_node = preload("res://node/character/rhythm_circle_node.tscn")
@onready var bpm_timer = $bpm_timer
@onready var metronome_path = $audio_metronome
@onready var metronome_sound = preload("res://audio/combat/metronome.wav")
@onready var hit_sound = preload("res://audio/music/hit_sound.wav")
@onready var miss_sound = preload("res://audio/music/miss_sound.wav")

@onready var enemy_healthbar = $combat_ui/Control/margin_labels/enemy_health/prog_healthbar
@onready var enemy_hp = $combat_ui/Control/margin_labels/enemy_health/enemy_hp
@onready var tilemap = $floor
@onready var tilemap_block = $tilemap_block

var player_current_position: Vector2 = Vector2(320, 97)
var player_default_position: Vector2 = Vector2(320, 97)
var player_left_position: Vector2 = Vector2(280, 97)
var player_right_position: Vector2 = Vector2(360, 97)
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
	metronome_enabled = Gamestate.option_metronome_enabled
	print("combat opponent is: ", opponent)
	# get rhythm map and song
	rhythm_map_song = "res://audio/music/fight/fight_%s.wav" % opponent
	find_valid_paths()

	await get_tree().process_frame
	await get_tree().process_frame
	audio_fight_music.play()

	#-
	Gamestate.combat_dodge_phase = true
	Gamestate.combat_choice_phase = false
	Gamestate.combat_fight_phase = false
	metronome_path.stream = metronome_sound
	start_metronome()
	player.position = player_hide_position


func find_valid_paths():

	# get rhythm map chart
	load_rhythm_chart("res://scene/combat/chart/chart_%s.json" % opponent)

	# get rhythm map song
	if !ResourceLoader.exists(rhythm_map_song):
		audio_fight_music.stream = load("res://audio/null.wav")
		push_error("ERR NOT FOUND - rhythm map song: " + rhythm_map_song)
		return

	audio_fight_music.stream = load(rhythm_map_song)
	print_debug("FOUND - rhythm map song: ", rhythm_map_song)


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

	# spawn rhythm notes
	var song_time = get_song_time()
	while rhythm_chart_index < rhythm_chart.size():
		var note_time = rhythm_chart[rhythm_chart_index]
		if note_time - song_time <= rhythm_spawn_ahead:
			spawn_note(note_time)
			rhythm_chart_index += 1
		else:
			break

	if Gamestate.combat_choice_phase == true:
		pass
	if Gamestate.combat_fight_phase == false:
		rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("ffffffff"))
		rhythm_hit_indicator_label.text = ""
		rhythm_hit_dmg_label.text = ""
	elif Gamestate.combat_fight_phase:
		pass
	if Gamestate.combat_dodge_phase == true:
		pass


var player_moved = false
func _physics_process(delta: float) -> void:
	var t: float = 0.0
	t += delta * 5
	var t2: float = 0.0
	t2 = delta * 250

	if Gamestate.combat_choice_phase == true:
		Gamestate.player_can_move = false
		player.hide()
		player_moved = false
		player.position = player_hide_position
		tilemap.position = tilemap_hide_position
		hitcircle.position = hitcircle_current_position.lerp(hitcircle_hide_position, t)

	elif Gamestate.combat_dodge_phase == true:
		player.show()
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
		player_moved = false
		player.position = player_hide_position
		tilemap.position = tilemap_hide_position
		hitcircle.position = hitcircle_current_position.lerp(hitcircle_default_position, t)

	#if rhythm_hit_counter == 5:
		#Gamestate.combat_dodge_phase = true


func start_metronome() -> void:
	while metronome_enabled and Gamestate.combat_fight_phase:
		metronome_path.play()
		bpm_timer.start()
		await bpm_timer.timeout
		if !metronome_enabled and !Gamestate.combat_fight_phase:
			break


# determine score awarded
func get_hit_score():
	if !Input.is_action_just_pressed("rhythm_key1") and !Input.is_action_just_pressed("rhythm_key2"):
		return
	var note = get_closest_note()

	if note.miss_sent:
		return

	if note == null:
		miss(note)
		return
	var song_time = get_song_time()
	var offset = abs(note.hit_time - song_time)

	if offset < 0.025:
		perfect_hit(note)
	elif offset < 0.05:
		good_hit(note)
	elif offset < 0.075:
		bad_hit(note)
	else:
		miss(note)
		anim_hitcircle.play("miss")
		if is_instance_valid(note):
			note.anim.play("miss")
			await note.anim.animation_finished
			note.queue_free()


func get_song_time() -> float:
	var time = audio_fight_music.get_playback_position()
	time += AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	return time


func perfect_hit(note):
	rhythm_hit_indicator_label.text = "perfect!"
	rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("6fb7ab"))
	rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("6fb7ab"))
	note_hit(note)


func good_hit(note):
	rhythm_hit_indicator_label.text = "good!"
	rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("87ad55"))
	rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("87ad55"))
	note_hit(note)


func bad_hit(note):
	rhythm_hit_indicator_label.text = "bad."
	rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("cdb75f"))
	rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("cdb75f"))
	note_hit(note)


func miss(note):

	rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("764559"))
	rhythm_hit_indicator_label.text = "miss."
	rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("764559"))

	rhythm_dmg_total -= Gamestate.player_damage / 8
	rhythm_hit_dmg_label.text = str(rhythm_dmg_total)
	audio_fight_sfx.stream = miss_sound
	audio_fight_sfx.play()


func _on_note_missed(note):
	if !is_instance_valid(note):
		return
	note.hit = true
	miss(note)
	note.anim.play("miss")
	await note.anim.animation_finished
	if is_instance_valid(note):
		note.queue_free()


func note_hit(note):
	note.hit = true
	enemy_healthbar.value -= Gamestate.player_damage
	enemy_hp.text = str(enemy_healthbar.value)
	rhythm_dmg_total += Gamestate.player_damage
	rhythm_hit_counter += 1
	rhythm_hit_dmg_label.text = str(rhythm_dmg_total)
	audio_fight_sfx.stream = hit_sound
	audio_fight_sfx.play()
	note.anim.play("hit")
	await note.anim.animation_finished
	if is_instance_valid(note):
		note.queue_free()


func load_rhythm_chart(path):

	var file = FileAccess.open(path, FileAccess.READ)

	var json = JSON.parse_string(file.get_as_text())

	rhythm_chart = json["notes"]
	bpm = json["bpm"]


func spawn_note(hit_time):

	var note = rhythm_note_node.instantiate()
	note.hit_time = hit_time
	note.scroll_speed = (bpm / 60.0) * 150
	note.hitcircle_position = hitcircle.position.x
	note.song_player = audio_fight_music
	note.position = Vector2(671, 97)
	note.missed.connect(_on_note_missed)
	add_child(note)


func get_closest_note():
	var closest = null
	var best_distance = 99999

	for note in get_tree().get_nodes_in_group("rhythm_note"):
		var d = abs(note.hit_time - get_song_time())
		if d < best_distance:
			best_distance = d
			closest = note
	return closest
