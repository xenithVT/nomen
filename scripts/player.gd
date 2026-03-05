extends CharacterBody2D

const speed = 75
var direction: Vector2 = Vector2.ZERO
var current_direction = "none"

func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)

func _physics_process(_delta):
	player_movement(_delta)
	debug()

func debug():
	if Input.is_action_just_pressed("debug") and Gamestate.debug_array != []:
		print_debug(Gamestate.debug_array)
	elif Input.is_action_just_pressed("debug") and Gamestate.debug_array == []:
		print_debug("no debug flags present")

func player_movement(_delta):
	if Gamestate.in_dialogue == false:
		direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
		direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	elif Gamestate.in_dialogue == true:
		pass
	
	velocity = direction * speed
	
	move_and_slide()
	pass

func play_anim(movement):
	var anim = $AnimatedSprite2D
	
	if current_direction == "right":
		anim.flip_h = false
		
