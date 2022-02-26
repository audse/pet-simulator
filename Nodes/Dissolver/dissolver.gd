class_name Dissolver
extends ColorRect

export (bool) var is_dissolved_on_start:bool = false

onready var dissolve_material:ShaderMaterial = preload("res://Assets/Materials/dissolve_material.tres")
onready var dissolve_texture:NoiseTexture
onready var parent_viewport:Viewport = get_viewport()


func _ready() -> void:
	# Ignore clicks
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Make dissolve shader unique
	material = dissolve_material.duplicate(true)
	dissolve_texture = material.get_shader_param("dissolve_texture")
	
	# Hide/show based on export
	if is_dissolved_on_start:
		material.set_shader_param("dissolve_value", 1)
	else:
		material.set_shader_param("dissolve_value", 0)


func _process(_delta: float) -> void:
	var viewport_rect := ViewportRef.get_viewport_rect(self, parent_viewport)
	
	# Set dissolve size to parent viewport size
	rect_global_position = viewport_rect.position
	rect_size = viewport_rect.size
	
	# Set noise size to parent viewport size
	dissolve_texture.width = viewport_rect.size.x
	dissolve_texture.height = viewport_rect.size.y


func dissolve_in(time:float=1.5, delay:float=0) -> void:
	yield(Timers.wait(delay), "completed")
	dissolve_texture.noise.seed = Globals.random.randi_range(0, 2000)
	Tweens.tween_material(
		self,
		"shader_param/dissolve_value",
		1,
		0,
		time,
		Tween.TRANS_LINEAR
	)


func dissolve_out(time:float=1.5, delay:float=0) -> void:
	yield(Timers.wait(delay), "completed")
	dissolve_texture.noise.seed = Globals.random.randi_range(0, 2000)
	Tweens.tween_material(
		self,
		"shader_param/dissolve_value",
		0,
		1,
		time,
		Tween.TRANS_LINEAR
	)
