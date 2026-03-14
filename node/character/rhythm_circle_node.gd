extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _on_spawn_area_area_entered(area: Area2D) -> void:
	#if area.is_in_group("spawn_area"):
	#	self.hide()
	#	$circle_body/miss_area.monitoring = false
	#	$circle_body/circle_area.monitoring = false
	#	$circle_body/circle_area.monitorable = false
	#if area.is_in_group("spawn_area") and area.is_in_group("spawn_area"):
	#	self.hide()
	#	$circle_body/miss_area.monitoring = false
	#	$circle_body/circle_area.monitoring = false
	#	$circle_body/circle_area.monitorable = false
