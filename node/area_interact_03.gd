extends Area2D

func interact():
	DialogueManager.show_dialogue_balloon_scene("res://node/dialogueballoon.tscn", load("res://script/dialogue/dev_03_intro.dialogue"), "start")
	Gamestate.in_dialogue = true
