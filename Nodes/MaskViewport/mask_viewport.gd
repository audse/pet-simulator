class_name MaskViewport
extends ViewportContainer

export (Shader) var mask_shader setget set_shader, get_shader

onready var nodes = {
	viewport = $Viewport,
	children = []
}

onready var parent_viewport:Viewport = get_viewport()


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	nodes.viewport.size = parent_viewport.size
	rect_size = parent_viewport.size
	
	# Add mask to mask viewport
	set_shader(mask_shader)


func _process(_delta: float) -> void:
	# Set viewport size to parent viewport size
	var viewport_transform = get_viewport_transform().affine_inverse().origin
	rect_global_position = viewport_transform
	nodes.viewport.canvas_transform = parent_viewport.canvas_transform


func set_shader(shader:Shader) -> void:
	material = ShaderMaterial.new()
	material.shader = shader


func get_shader() -> Shader:
	return material.shader
