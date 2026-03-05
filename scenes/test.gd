extends Node2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		DialogueManager.show_dialogue_balloon(load("res://scripts/dialogue/dev_03_intro.dialogue"), "start")
		Gamestate.in_dialogue = true
		pass
