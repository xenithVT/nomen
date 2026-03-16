extends Node2D
class_name RhythmNote

signal missed(note)
var hit_time: float
var scroll_speed: float
var hitcircle_position: float
var hit = false
var miss_sent = false

var song_player: AudioStreamPlayer
@onready var anim = $circle_body/AnimationPlayer


func _ready() -> void:
	add_to_group("rhythm_note")


func _process(delta: float) -> void:
	if hit or miss_sent:
		return
	if song_player == null:
		return
	var song_time = get_song_time()
	var time_until_hit = hit_time - song_time
	position.x = hitcircle_position + time_until_hit * scroll_speed
	if song_time > hit_time + 0.2:
		miss_sent = true
		missed.emit(self)


func get_song_time():

	var time = song_player.get_playback_position()
	time += AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	return time
