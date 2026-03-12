extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	discord_presence()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _exit_level(body) -> void:
	#if body.name == "player":
		#print("Left level")
		#scene_transition.fade(1.0, 1.5)


# discord presence
func discord_presence():
	DiscordRPC.app_id = 1481388500812169327  # Application ID
	DiscordRPC.details = "A demo activity by vaporvee"
	DiscordRPC.state = "Checkpoint 23/23"
	DiscordRPC.large_image = "example_game"  # Image key from "Art Assets"
	DiscordRPC.large_image_text = "Try it now!"
	DiscordRPC.small_image = "boss"  # Image key from "Art Assets"
	DiscordRPC.small_image_text = "Fighting the end boss! D:"

	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())  # "02:46 elapsed"
	# DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00:00 remaining"

	DiscordRPC.refresh()  # Always refresh after changing the values!
	print("Discord working: " + str(DiscordRPC.get_is_discord_working()))
