extends Area2D
class_name SceneTransition

@onready var player = get_tree().current_scene.find_child("player")
var anim_transitions
@export_file("*.tscn") var next_scene_path: String
var next_scene_fallback: String = "res://scene/level_err.tscn"


func _ready():
	anim_transitions = player.find_child("canvas_transitions")
	self.add_to_group("scene_transition")


func scene_transition():
	if next_scene_path:
		print_debug("FOUND - scene path - transitioning...")
		anim_transitions.fade_out()
		await get_tree().create_timer(1.25).timeout
		get_tree().change_scene_to_file(next_scene_path)
	elif !next_scene_path:
		push_error("ERR - invalid scene path. fallback used instead")
		anim_transitions.fade_out()
		await get_tree().create_timer(1.25).timeout
		get_tree().change_scene_to_file("res://scene/level_err.tscn")
	else:
		pass
	Gamestate.in_dialogue = false
