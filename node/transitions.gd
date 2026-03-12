extends CanvasLayer

@onready var rect_fade = $rect_fade
@onready var player = get_parent()
@onready var anim_transitions = $anim_transitions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rect_fade.color = Color.BLACK
	self.show()


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	pass


func no_transition():
	self.hide()


func fade_in():
	self.show()
	anim_transitions.play("fade_in")
	await get_tree().create_timer(2).timeout


func fade_out():
	self.show()
	anim_transitions.play("fade_out")
	await get_tree().create_timer(2).timeout
