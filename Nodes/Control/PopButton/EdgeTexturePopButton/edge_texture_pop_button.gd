class_name EdgeTexturePopButton
extends PopButton

export (Texture) var texture:Texture
export (StyleBox) var edge_stylebox:StyleBox
export (bool) var expand:bool = true
enum TextureStretchMode {
	KEEP,
	KEEP_CENTERED,
	KEEP_ASPECT,
	KEEP_ASPECT_CENTERED,
	KEEP_ASPECT_COVERED,
	SCALE,
	SCALE_ON_EXPAND,
	TILE
}
export (TextureStretchMode) var stretch_mode:int = TextureStretchMode.TILE
export (Color) var texture_modulate:Color = Color("#ffffff")
export (Color) var edge_modulate:Color = Color("#ffffff")

func _ready() -> void:
	set_texture(texture)
	set_edge_stylebox(edge_stylebox)
	set_texture_mode(expand, stretch_mode)
	set_texture_modulate(texture_modulate)
	set_edge_modulate(edge_modulate)


func set_texture_modulate(new_modulate:Color) -> void:
	$Margin/Texture.self_modulate = new_modulate


func set_edge_modulate(new_modulate:Color) -> void:
	$Edge.self_modulate = new_modulate


func set_texture_mode(expand_setting:bool, stretch_mode_setting:int=TextureStretchMode.TILE) -> void:
	$Margin/Texture.expand = expand_setting
	match stretch_mode_setting:
		TextureStretchMode.KEEP:
			$Margin/Texture.stretch_mode = TextureRect.STRETCH_KEEP
		TextureStretchMode.KEEP_CENTERED:
			$Margin/Texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		TextureStretchMode.KEEP_ASPECT:
			$Margin/Texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		TextureStretchMode.KEEP_ASPECT_CENTERED:
			$Margin/Texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		TextureStretchMode.KEEP_ASPECT_COVERED:
			$Margin/Texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		TextureStretchMode.SCALE:
			$Margin/Texture.stretch_mode = TextureRect.STRETCH_SCALE
		TextureStretchMode.SCALE_ON_EXPAND:
			$Margin/Texture.stretch_mode = TextureRect.STRETCH_SCALE_ON_EXPAND
		TextureStretchMode.TILE:
			$Margin/Texture.stretch_mode = TextureRect.STRETCH_TILE


func set_texture(new_texture:Texture) -> void:
	texture = new_texture
	$Margin/Texture.texture = new_texture


func set_edge_stylebox(new_stylebox:StyleBox) -> void:
	$Edge.add_stylebox_override("NewStylebox", new_stylebox)
	
