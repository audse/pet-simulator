class_name MaskViewport
extends ProcessViewportContainer

export (Shader) var mask_shader setget set_shader, get_shader

onready var nodes = {
	viewport = $Viewport,
	children = []
}

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Add mask to mask viewport
	set_shader(mask_shader)


func set_shader(shader:Shader) -> void:
	material = ShaderMaterial.new()
	material.shader = shader


func get_shader() -> Shader:
	return material.shader
