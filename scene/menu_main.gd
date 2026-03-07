extends Node2D

#func _ready() -> void:
	#DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/test.tscn")
