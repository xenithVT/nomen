extends Node2D

@onready var combat_ui = $combat_ui
@onready var player = $player_combat

@onready var hitcircle = $hitcircle
var rhythm_map_path: String
var rhythm_map_scene: PackedScene
var rhythm_map: Node2D
var metronome_path
var bpm_timer
@onready var rhythm_hit_indicator_label = $combat_ui/Control/margin_fight_ui/VBoxContainer/label_hit_indicator
@onready var rhythm_hit_dmg_label = $combat_ui/Control/margin_fight_ui/VBoxContainer/label_hit_dmg
@onready var metronome_sound = preload("res://audio/combat/metronome.wav")

@onready var tilemap = $floor

var player_current_position: Vector2 = Vector2(320, 97)
var player_default_position: Vector2 = Vector2(320, 97)
var tilemap_default_position: Vector2 = Vector2(10, -144)
var tilemap_hide_position: Vector2 = Vector2(-518, -144)
var player_hide_position: Vector2 = Vector2(-208, 97)

var hitcircle_current_position: Vector2 = Vector2(320, -47)
var hitcircle_default_position: Vector2 = Vector2(320, 97)
var hitcircle_hide_position: Vector2 = Vector2(320, -47)

var rhythm_map_current_position: Vector2 = Vector2(640, 96)
var rhythm_map_spawn_position: Vector2 = Vector2(640, 96)
var rhythm_map_left_position: Vector2 = Vector2(-999, 96)

var rhythm_great = false
var rhythm_good = false
var rhythm_bad = false
var rhythm_miss = true
var rhythm_dmg_total: int = 0

var metronome_enabled


func _ready() -> void:
	metronome_enabled = Gamestate.metronome_enabled
	print("combat opponent is: ", Gamestate.combat_opponent)
	# get rhythm map
	rhythm_map_path = "res://node/rhythm_map/map_%s_fight.tscn" % Gamestate.combat_opponent
	if ResourceLoader.exists(rhythm_map_path):
		rhythm_map_scene = load(rhythm_map_path)
		print_debug("FOUND - rhythm map: ", rhythm_map_path)
		add_child(rhythm_map_scene.instantiate())
		rhythm_map = get_node("map_%s_fight" % Gamestate.combat_opponent)
		print(rhythm_map)
		metronome_path = get_node("map_%s_fight/metronome" % Gamestate.combat_opponent)
		bpm_timer = get_node("map_%s_fight/bpm_timer" % Gamestate.combat_opponent)
	else:
		print_debug("ERR NOT FOUND - rhythm map: ", rhythm_map_path)
	Gamestate.combat_choice_phase = true
	start_metronome()


func _unhandled_input(event: InputEvent) -> void:
	# combat choice thing for debugging
	if Input.is_action_just_pressed("pause_menu") and Gamestate.combat_choice_phase:
		Gamestate.combat_choice_phase = false
		Gamestate.combat_fight_phase = true
		print_debug(player.position)
	elif Input.is_action_just_pressed("pause_menu") and !Gamestate.combat_choice_phase:
		Gamestate.combat_choice_phase = true
		Gamestate.combat_fight_phase = false

	if Gamestate.combat_fight_phase == true:
		if Input.is_action_just_pressed("ui_cancel") and rhythm_great == true:
			rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("6fb7ab"))
			rhythm_hit_indicator_label.text = "great!"

			rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("6fb7ab"))
			rhythm_dmg_total += Gamestate.player_damage
			rhythm_hit_dmg_label.text = str(rhythm_dmg_total)

			#await get_tree().create_timer(0.8).timeout
			#rhythm_hit_indicator_label.text = ""

		if Input.is_action_just_pressed("ui_cancel") and rhythm_good == true:
			rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("afc168"))
			rhythm_hit_indicator_label.text = "good!"

			rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("afc168"))
			rhythm_dmg_total += Gamestate.player_damage / 2
			rhythm_hit_dmg_label.text = str(rhythm_dmg_total)
			#await get_tree().create_timer(0.8).timeout

			#rhythm_hit_indicator_label.text = ""

		if Input.is_action_just_pressed("ui_cancel") and rhythm_bad == true:
			rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("cdb75f"))
			rhythm_hit_indicator_label.text = "bad..."

			rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("afc168"))
			rhythm_dmg_total += Gamestate.player_damage / 8
			rhythm_hit_dmg_label.text = str(rhythm_dmg_total)
			#await get_tree().create_timer(0.8).timeout

			#rhythm_hit_indicator_label.text = ""

		if Input.is_action_just_pressed("ui_cancel") and rhythm_miss == true:
			rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("764559"))
			rhythm_hit_indicator_label.text = "miss."

			rhythm_hit_dmg_label.add_theme_color_override("font_color", Color("afc168"))
			rhythm_dmg_total -= Gamestate.player_damage / 8
			rhythm_hit_dmg_label.text = str(rhythm_dmg_total)
			#await get_tree().create_timer(0.8).timeout

			#rhythm_hit_indicator_label.text = ""


# process
func _process(delta: float) -> void:
	player_current_position = player.position
	hitcircle_current_position = hitcircle.position
	rhythm_map_current_position = rhythm_map.position

	if Gamestate.combat_fight_phase == false:
		rhythm_hit_indicator_label.add_theme_color_override("font_color", Color("ffffffff"))
		rhythm_hit_indicator_label.text = ""


func _physics_process(delta: float) -> void:
	var t: float = 0.0
	t += delta * 5
	var t2: float = 0.0
	t2 = delta * 125
	if Gamestate.combat_choice_phase == true:
		player.position = player_default_position
		tilemap.position = tilemap_default_position
		hitcircle.position = hitcircle_current_position.lerp(hitcircle_hide_position, t)
		rhythm_map.position = rhythm_map_current_position.move_toward(rhythm_map_spawn_position, t)
	elif Gamestate.combat_fight_phase == true:
		player.position = player_hide_position
		tilemap.position = tilemap_hide_position
		hitcircle.position = hitcircle_current_position.lerp(hitcircle_default_position, t)
		rhythm_map.position = rhythm_map_current_position.move_toward(rhythm_map_left_position, t2)


func start_metronome() -> void:
	while metronome_enabled:
		metronome_path.stream = metronome_sound
		metronome_path.play()
		bpm_timer.start()
		await bpm_timer.timeout


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
		rhythm_bad = true
		rhythm_miss = false


func _on_bad_area_exited(area: Area2D) -> void:
	if area.is_in_group("rhythm_circle"):
		rhythm_bad = false
		rhythm_miss = true
