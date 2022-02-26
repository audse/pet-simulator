class_name DesignTextureManager
extends ResourceManager


func _init() -> void:
	data_path = "res://Assets/Data/designs.json"
	data = load_file_data(data_path)


func get_icon_texture_array(type_id:String, category_id:String) -> Array:
	var designs:Array = []
	
	var type:Dictionary = get_type(data, type_id)
	var category:Dictionary = get_category(type, category_id)
	
	if not "path" in type or not "path" in category: return designs
	
	var path_prefix:String = data["designs"]["path"]
	path_prefix += type["path"]
	path_prefix += category["path"]
	
	var file:File = File.new()
	var file_exists:bool = false
	
	for tile in category["tiles"]:
		for option in tile["options"]:
			var texture_path:String = (
					path_prefix + 
					create_icon_file_name(tile, option)
			)
			
			file_exists = file.file_exists(texture_path)
			if file_exists:
				designs.append({
					tile = tile,
					option = option,
					texture = load(texture_path)
				})
	
	return designs


func find_texture(
		id:String,
		option:String,
		view_state:int=Globals.View.DEFAULT
	) -> Texture:
		
		var texture_path:String = ""
		var texture:Texture
		
		if "designs" in data:
			texture_path += data["designs"]["path"]
			
			for type in data["designs"]["types"]:
				for category in type["categories"]:
					for tile in category["tiles"]:
						
						if tile["id"] == id:
							texture_path += type["path"]
							texture_path += category["path"]
							
							texture_path += create_file_name(
									tile,
									option,
									view_state
							)
							break
							
		var file:File = File.new();
		var file_exists:bool = file.file_exists(texture_path)
		if file_exists:
			texture = load(texture_path)
		
		return texture


static func create_file_name(tile:Dictionary, option:String, view_state:int) -> String:
	var file_name:String = tile["path"]
	
	if not option in tile["options"]: return file_name
	file_name += "_" + option
	
	if not tile["is_single_tile"]:
		file_name += "_masked"
	
	if view_state == Globals.View.CUTAWAY:
		file_name += "_cutaway"
	
	file_name += ".png"
	
	return file_name


static func create_icon_file_name(tile:Dictionary, option:String) -> String:
	var tile_path:String = tile["path"]
	if "/" in tile_path:
		tile_path = tile_path.split("/")[1]
	
	var file_name:String = "icon/" + tile_path
	
	if not option in tile["options"]: return file_name
	file_name += "_" + option
	
	file_name += ".png"
	return file_name


static func get_type(data_value:Dictionary, type_id:String) -> Dictionary:
	if not "designs" in data_value: return {}
	
	for type in data_value["designs"]["types"]:
		if type["id"] == type_id:
			return type
	
	return {}


static func get_category(type:Dictionary, category_id:String) -> Dictionary:
	if not "categories" in type: return {}
	
	for category in type["categories"]:
		if category["id"] == category_id:
			return category
	
	return {}


static func get_tile(category:Dictionary, tile_id:String) -> Dictionary:
	if not "tiles" in category: return {}
	
	for tile in category["tiles"]:
		if tile["id"] == tile_id:
			return tile
	
	return {}
