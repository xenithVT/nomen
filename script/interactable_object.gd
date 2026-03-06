extends Area2D

class_name InteractableObject

@export var dialogue_file: Resource
@export var dialogue_balloon: PackedScene
@export var dialogue_label: String = "start"

var dialogue_path_fallback: String = "res://script/dialogue/fallback.dialogue"
var dialogue_balloon_path_fallback: String = "res://node/dialogueballoon.tscn"


func interact():
	if dialogue_file and dialogue_balloon:
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon, dialogue_file, "start")
		print_debug(dialogue_file)
		print_debug(dialogue_balloon)
	elif !dialogue_file:
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon_path_fallback, 
		load(dialogue_path_fallback), "dialogue_path_fail")
		print_debug("invalid path")
		print_debug(dialogue_file)
		print_debug(dialogue_balloon)
	elif !dialogue_balloon:
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon_path_fallback, 
		load(dialogue_path_fallback), "dialogue_balloon_path_fail")
		print_debug("invalid balloon path")
		print_debug(dialogue_file)
		print_debug(dialogue_balloon)
	else:
		DialogueManager.show_dialogue_balloon_scene(dialogue_balloon_path_fallback, 
		load(dialogue_path_fallback), "generic_fail")
		print_debug("invalid path and/or balloon path")
		print_debug(dialogue_file)
		print_debug(dialogue_balloon)
	Gamestate.in_dialogue = true
