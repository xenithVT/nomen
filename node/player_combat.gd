extends CharacterBody2D

# variables
const speed: float = 150
var direction: Vector2 = Vector2.ZERO
var debug_shown = false
@onready var hitbox = $Area2D
@onready var audio_stream_player = $AudioStreamPlayer
# ---------------


# start functions
func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
# ---------------


# process functions
func _process(_delta):
	player_movement(_delta)
	debug()
	player_death()


func _physics_process(_delta: float) -> void:
	move_and_slide()
# ---------------


# handle input
func _unhandled_input(event: InputEvent) -> void:
	pass
# ---------------


# player movement
func player_movement(_delta):
	if Gamestate.in_dialogue == false and Gamestate.player_can_move == true:
		direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		direction = direction.normalized()
		velocity = direction * speed
	elif Gamestate.in_dialogue == true or Gamestate.player_can_move == false:
		velocity = Vector2(0, 0)
# ---------------


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		Playermanager.take_damage(50)
		audio_stream_player.stream = load("res://audio/combat/take_dmg.wav")
		audio_stream_player.play()
		#await get_tree().create_timer(1).timeout


func player_death():
	if Playermanager.player_health == 0:
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file("res://scene/combat_scene.tscn")
		Playermanager.player_health = Playermanager.default_player_health
		print("player health 0")


# debug
func debug():
	if Input.is_action_just_pressed("debug"):
		if Gamestate.debug_array.is_empty():
			print_debug("no debug flags present")
		else:
			Input.is_action_just_pressed("debug")
			print_debug(Gamestate.debug_array)
# ---------------
