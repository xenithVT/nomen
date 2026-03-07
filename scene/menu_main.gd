extends Node2D

var audio_stream_player: AudioStreamPlayer


func _ready() -> void:
	audio_stream_player = $AudioStreamPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	audio_stream_player.stream = load("res://audio/menu/select.wav")
	audio_stream_player.play()
	audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	get_tree().change_scene_to_file("res://scene/test.tscn")
