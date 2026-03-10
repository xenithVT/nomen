extends Node

var save_location = "user://save.json"


func _ready():
	pass


func save_game():
	var data = {
		"pipcounter": Dialoguestate.pipcounter,
	}

	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


func load_game():
	if !FileAccess.file_exists(save_location):
		return

	var file = FileAccess.open(save_location, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	SaveData.pipcounter = data.get("pipcounter", 0)
