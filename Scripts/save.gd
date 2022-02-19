class_name Save
extends Node

var file_name:String = "savegame"


func _init(new_file_name:String=file_name) -> void:
	file_name = new_file_name


func setup(new_file_name) -> void:
	file_name = new_file_name


func save_data(save_data:Dictionary) -> void:
	print("Saving data... ")
	var save_game:File = File.new()
	var _open = save_game.open(get_file_path(), File.WRITE)
	save_game.store_var(save_data, true)
	save_game.close()


func load_data() -> Dictionary:
	var save_data:Dictionary = {}
	
	# Attempt to open save file
	var save_game:File = File.new()
	var file_path:String = get_file_path()
	if save_game.file_exists(file_path):
		var _open = save_game.open(file_path, File.READ)
		
		save_data = save_game.get_var(true)
		save_game.close()
		
	print("Loading save data... ")
	return save_data


func get_file_path() -> String:
	return "user://" + file_name + ".save"
