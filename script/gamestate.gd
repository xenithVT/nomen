extends Node

var game_version = "0.5"


# game start stuff
func ready():
	pass

# global variables
var current_route = "neutral"
var in_dialogue = false
var debug_array = []

# combat variables
var start_combat = false
enum combat_phase { CHOICE, DODGE, FIGHT }
var combat_choice_phase = false
var combat_fight_phase = false
var combat_dodge_phase = false
var player_damage = 20
var combat_opponent: String = "torin"
var metronome_enabled = true
var player_can_move = true


# debug stuff
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
		debug()


func debug():
	if in_dialogue == true and !debug_array.has("in dialogue"):
		debug_array.append("in dialogue")
	if in_dialogue == false:
		debug_array.erase("in dialogue")
	if !debug_array.has(current_route):
		debug_array.append(current_route)
