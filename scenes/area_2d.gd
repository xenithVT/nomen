extends Area2D


func interact():
	DialogueManager.show_dialogue_balloon(load("res://scripts/dialogue/dev_wall.dialogue"), "start")
	Gamestate.in_dialogue = true
