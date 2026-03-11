extends Node

# inventory
var grass_power = false

# stats
var player_health: int = 100
var default_player_health: int = 100
var player_spirit: int = 100
var player_defense: int = 1
var xp = 0
var lvl = 0


# take damage
func take_damage(dmg: int):
	if player_health > 0:
		player_health -= dmg
	else:
		player_health = 0
