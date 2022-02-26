class_name Save extends Node

export (String) var file_name = "savegame"
export (bool) var logging_enabled = true


func _init(new_file_name:String=file_name) -> void:
	file_name = new_file_name


func setup(new_file_name:String) -> void:
	file_name = new_file_name


func save_data(save_data:Dictionary) -> void:
	if logging_enabled:
		print("\nSaving data... ")
		print(save_data)
	var save_game:File = File.new()
	var _open = save_game.open(get_file_path(), File.WRITE)
	save_game.store_var(save_data, true)
	save_game.close()


func load_data() -> Dictionary:
	var save_data:Dictionary = {}
	var file_path:String = get_file_path()
	
	# Attempt to open save file
	var save_game:File = File.new()
	if save_game.file_exists(file_path):
		var _open = save_game.open(file_path, File.READ)
		
		save_data = save_game.get_var(true)
		save_game.close()
	
	if logging_enabled:
		print("\nLoading save data... ")
		prints("\tfrom", file_path)
	
	return save_data


func get_file_path() -> String:
	return "user://" + file_name + ".save"
