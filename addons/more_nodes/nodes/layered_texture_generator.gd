class_name LayeredTextureGenerator
extends ViewportContainer

signal texture_generated(texture)

export (Array, Texture) var textures setget set_textures, get_textures
export (Vector2) var texture_size
export (bool) var logging_enabled = true

var viewport := Viewport.new()


func _init() -> void:
	viewport.size_override_stretch = true
	viewport.usage = Viewport.USAGE_2D
	viewport.transparent_bg = true
	viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	visible = false
	


func _enter_tree() -> void:
	add_child(viewport)
	set_textures(textures)


func get_texture() -> void:
	# Wait for viewport to update
	yield(Timers.wait(0.1), "completed")
	
	# Get image data (flipped)
	var image := (viewport as Viewport).get_texture().get_data()
	image.flip_y()
	var texture := ImageTexture.new()
	texture.create_from_image(image)
	
	# Emit new texture
	if logging_enabled: prints("Layered Texture: Generated from", len(textures), "textures")
	emit_signal("texture_generated", texture)


func get_size() -> Vector2:
	if texture_size: return texture_size
	if len(textures) > 0: return textures[0].get_size()
	return Vector2.ZERO


func set_textures(texture_list:Array) -> void:
	textures = texture_list
	
	if is_inside_tree():
		if viewport and is_instance_valid(viewport) and viewport.is_inside_tree():
			rect_size = get_size()
			viewport.size = get_size()
			
			for texture in texture_list:
				var new_sprite := Sprite.new()
				new_sprite.texture = texture
				new_sprite.centered = false
				viewport.add_child(new_sprite)


func get_textures() -> Array:
	return textures


func clear() -> void:
	for child in get_children():
		child.queue_free()
