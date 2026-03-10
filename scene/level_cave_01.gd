extends Node2D
@onready var scene_transition = $player/scene_transition


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _exit_level(body) -> void:
	#if body.name == "player":
		#print("Left level")
		#scene_transition.fade(1.0, 1.5)
