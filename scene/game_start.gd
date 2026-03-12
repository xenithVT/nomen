extends Node2D

@onready var anim = $AnimationPlayer
@onready var audio = $AudioStreamPlayer
@onready var title_screen = $title
@onready var engine_screen = $engine_credit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	engine_screen.hide()
	await get_tree().process_frame
	await get_tree().create_timer(0.4).timeout
	title_screen.show()
	await get_tree().create_timer(2).timeout
	title_screen.hide()
	engine_screen.show()
	await get_tree().create_timer(2).timeout
	anim.play("godot_wink")
	audio.stream = load("res://audio/menu/wink.wav")
	audio.play()
	await get_tree().create_timer(2).timeout
	anim.play("fade out")
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scene/menu_main.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
