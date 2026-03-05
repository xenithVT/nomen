extends Area2D

func interact():
	DialogueManager.show_dialogue_balloon(load("res://scripts/dialogue/dev_03_intro.dialogue"), "start")
	Gamestate.in_dialogue = true
