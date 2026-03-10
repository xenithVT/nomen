extends Node

var combat = false
var in_combat = false


# check for if you're in combat or not (if combat is set to true via dialogue then set in_combat to true
func _physics_process(delta: float) -> void:
	if combat == true:
		in_combat = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# if var combat is set to true via dialogue then begin combat
func start_combat():
	if in_combat == true:
		print_debug("combat started")
