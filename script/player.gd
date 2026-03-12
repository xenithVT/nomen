extends CharacterBody2D

# variables
const speed: float = 85
var direction: Vector2 = Vector2.ZERO
var current_direction = "none"
var last_direction := Vector2.DOWN
var debug_shown = false
@onready var pivot = $pivot
@onready var pause_menu = $canvas_pausemenu
@onready var anim_transition = $canvas_transitions
var target_angle: float
var interact_target = null
@onready var health = Playermanager.player_health
# ---------------


# start functions
func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	anim_transition.fade_in()
# ---------------


# process functions
func _process(_delta):
	debug()
	play_anim(_delta)
	start_combat()


func _physics_process(_delta: float) -> void:
	player_movement(_delta)
	move_and_slide()
# ---------------



# interaction
func _on_area_interact_player_area_entered(area: Area2D) -> void:
	interact_target = area
	#print_debug(area)
func _on_area_interact_player_area_exited(area: Area2D) -> void:
	if interact_target == area:
		interact_target = null
		#print_debug(area)
# ---------------


# scene transitions
func _on_hitbox_player_area_entered(area: Area2D) -> void:
	if area.is_in_group("scene_transition"):
		area.scene_transition()
	else:
		pass


# handle input
func _unhandled_input(event: InputEvent) -> void:
	# interact input
	if event.is_action_pressed("ui_accept") and interact_target != null and !Gamestate.in_dialogue:
		interact_target.interact()
	else:
		#print_debug("interaction failed")
		pass
	if event.is_action_pressed("ui_cancel") and Gamestate.in_dialogue:
		pass

	# inventory input
	if Input.is_action_just_pressed("inventory"):
		pass

# ---------------


# player movement
func player_movement(_delta):
	if Gamestate.in_dialogue == false:
		direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		direction = direction.normalized()
	elif Gamestate.in_dialogue == true:
		pass
	velocity = direction * speed

	if direction != Vector2.ZERO:
		last_direction = direction
		pivot.rotation = direction.angle()
	else:
		pivot.rotation = last_direction.angle()
# ---------------


func start_combat():
	if Gamestate.start_combat == true:
		get_tree().change_scene_to_file("res://scene/combat_scene.tscn")


func play_anim(_movement):
	var anim = $animation_player

	#if direction == Vector2.DOWN:
		#anim.play("down_walk")
	#if last_direction == Vector2.LEFT:
		#anim.play("side")
		#anim.flip_h = false
	#if last_direction == Vector2.RIGHT:
		#anim.play("side")
		#anim.flip_h = true
	#if last_direction == Vector2.UP:
		#anim.play("up")
		#anim.flip_h = false
	#if last_direction == Vector2.DOWN:
		#anim.play("idle")
		#anim.flip_h = false
# ---------------


# debug
func debug():
	if Input.is_action_just_pressed("debug"):
		print_debug(Dialoguestate.pipcounter)
		if Gamestate.debug_array.is_empty():
			print_debug("no debug flags present")
		else:
			Input.is_action_just_pressed("debug")
			print_debug(Gamestate.debug_array)

	if Input.is_action_just_pressed("debug") and debug_shown == false:
		get_tree().debug_collisions_hint = true
		debug_shown = true
	elif Input.is_action_just_pressed("debug") and debug_shown == true:
		get_tree().debug_collisions_hint = false
		debug_shown = false
# ---------------
