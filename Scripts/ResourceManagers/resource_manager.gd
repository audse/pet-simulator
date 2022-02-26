class_name ResourceManager
extends Resource

export (String) var data_path:String

var data:Dictionary = {}

static func load_file_data(file_name:String=data_path) -> Dictionary:
	var file:File = File.new()
	var _open = file.open(file_name, file.READ)
	var contents:String = file.get_as_text()
	return JSON.parse(contents).result
	
