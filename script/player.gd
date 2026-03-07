extends CharacterBody2D

# variables
const speed: float = 80
var direction: Vector2 = Vector2.ZERO
var current_direction = "none"
var last_direction := Vector2.DOWN
var debug_shown = false
@onready var interact_area = $pivot/area_interact_player
@onready var pivot = $pivot
var target_angle: float
var interact_target = null
# ---------------


# start functions
func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
# ---------------


# process functions
func _process(_delta):
	player_movement(_delta)
	debug()
	play_anim(_delta)


func _physics_process(_delta: float) -> void:
	move_and_slide()
# ---------------


# debug
func debug():
	if Input.is_action_just_pressed("debug") and Gamestate.debug_array != []:
		print_debug(Gamestate.debug_array)
	elif Input.is_action_just_pressed("debug") and Gamestate.debug_array == []:
		print_debug("no debug flags present")

	if Input.is_action_just_pressed("debug") and debug_shown == false:
		$hitbox_player/shape_hitbox_player/debug_hitbox.show()
		$pivot/area_interact_player/shape_interact_player/debug_interact_hitbox.show()
		debug_shown = true
	elif Input.is_action_just_pressed("debug") and debug_shown == true:
		$hitbox_player/shape_hitbox_player/debug_hitbox.hide()
		$pivot/area_interact_player/shape_interact_player/debug_interact_hitbox.hide()
		debug_shown = false
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
	elif Gamestate.in_dialogue == true:
		pass
	velocity = direction * speed

	if direction != Vector2.ZERO:
		last_direction = direction
		pivot.rotation = direction.angle()
	else:
		pivot.rotation = last_direction.angle()
# ---------------


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
