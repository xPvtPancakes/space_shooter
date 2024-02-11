extends Resource

class_name SaveGame

@export var high_score: Dictionary
var save_path = "user://scoresave.tres"

var gameSave = SaveGame.new()

func save_game():
	ResourceSaver.save(gameSave, save_path)

func load_game():
	if FileAccess.file_exists(save_path):
		gameSave=ResourceLoader.load(save_path + "save").duplicate(true)
		high_score = gameSave.high_scores
	else:
		printerr('No save file found')
