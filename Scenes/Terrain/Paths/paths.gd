extends ViewportContainer

export(Texture) var design_texture:Texture = preload("res://Assets/Terrain/Paths/Designs/Exports/simple-large-brick.png")
export(Texture) var shape_texture:Texture = preload("res://Assets/Terrain/Paths/Shapes/Exports/path-basic.png")
export(float) var path_width:float = 24
export(float) var randomness:float = 3.0
export(Color) var modulate_color:Color = Color("#cccccc")

onready var parent_viewport:Viewport = get_viewport()
onready var draw_material:CanvasItemMaterial = CanvasItemMaterial.new()
onready var erase_material:CanvasItemMaterial = CanvasItemMaterial.new()

var currently_drawing_path:Line2D = null
var is_erasing:bool = false


func _ready() -> void:
	# Create materials
	draw_material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	erase_material.blend_mode = CanvasItemMaterial.BLEND_MODE_SUB
	
	# Attach viewport to current camera
	$Viewport.size = parent_viewport.size
	
	# Update texture with design
	$Viewport/Texture.texture = design_texture

func _unhandled_input(event:InputEvent) -> void:
	
	if event is InputEventScreenDrag:
		
		if not currently_drawing_path:
			currently_drawing_path = create_path()
			$Viewport.add_child(currently_drawing_path)
			if not is_erasing:
				$Viewport.move_child(currently_drawing_path, 0)
				currently_drawing_path.material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
			else:
				currently_drawing_path.material.blend_mode = CanvasItemMaterial.BLEND_MODE_SUB
			
		get_tree().set_input_as_handled()
			
		
	if event.is_action_released("ui_touch"):
		
		if currently_drawing_path:
			cull_points(currently_drawing_path)
			currently_drawing_path = null
			

func _process(_delta:float) -> void:
	
	if currently_drawing_path:
		var new_point:Vector2 = get_parent().make_canvas_position_local(get_viewport().get_mouse_position())
		new_point += Vector2(
				Globals.random.randf_range(-randomness, randomness),
				Globals.random.randf_range(-randomness, randomness)
		)
		currently_drawing_path.add_point(new_point)
	
	# Set viewport size to parent viewport size
	rect_global_position = get_viewport_transform().affine_inverse().origin
	$Viewport.canvas_transform = parent_viewport.canvas_transform

func create_path() -> Line2D:
	var new_path:Line2D = Line2D.new()
	new_path.texture = shape_texture
	new_path.material = CanvasItemMaterial.new()
	new_path.texture_mode = Line2D.LINE_TEXTURE_TILE
	new_path.joint_mode = Line2D.LINE_JOINT_ROUND
	new_path.begin_cap_mode = Line2D.LINE_CAP_ROUND
	new_path.end_cap_mode = Line2D.LINE_CAP_ROUND
	new_path.round_precision = 4
	new_path.default_color = modulate_color
	new_path.width = path_width
	new_path.material = CanvasItemMaterial.new()
	return new_path

func cull_points(path:Line2D) -> void:
	var new_points:Array = []
	var prev_point:Vector2 = Vector2.ZERO
	for point in path.points:
		if prev_point == Vector2.ZERO or point.distance_to(prev_point) > 5:
			new_points.append(point)
		prev_point = point
	
	path.clear_points()
	for point in new_points:
		path.add_point(point)

func undo() -> void:
	pass

func redo() -> void:
	pass

