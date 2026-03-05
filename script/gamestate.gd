extends Node

# game start stuff
#func start():
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# global variables
var current_route = "neutral"
var in_dialogue = false
var debug_array = []

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
