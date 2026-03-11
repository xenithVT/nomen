extends CanvasLayer

class_name CombatScene

@onready var hp_label = $Control/margin_labels/MarginContainer/HBoxContainer/label_player_hp
@onready var sp_label = $Control/margin_labels/MarginContainer/HBoxContainer/label_player_power
@onready var container_buttons = $Control/container_player_options/PanelContainer/container_buttons
@onready var button_fight = $Control/container_player_options/PanelContainer/MarginContainer/container_buttons/button_fight
@onready var audio_stream_player = $audiostreamplayer_combat
var buttons_focused = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_fight.grab_focus()
	buttons_focused = true
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hp_label.text = str("hp: ", Playermanager.player_health)
	sp_label.text = str("sp: ", Playermanager.player_spirit)

	if Gamestate.combat_choice_phase == true and buttons_focused == false:
		button_fight.grab_focus()
		buttons_focused = true
	if Gamestate.in_dialogue == true:
		pass
	elif Gamestate.combat_choice_phase == false:
		get_viewport().gui_release_focus()
		buttons_focused = false


func _on_button_fight_button_down() -> void:
	Gamestate.combat_choice_phase = false
	Gamestate.combat_dodge_phase = false
	Gamestate.combat_fight_phase = true
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
