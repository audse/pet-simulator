extends Node

enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN,
	NONE
}

enum Axis {
	NONE,
	HORIZONTAL,
	VERTICAL
}

enum View {
	DEFAULT,
	CUTAWAY
}

func print_direction(direction:int) -> void:
	match direction:
		Direction.LEFT:
			print("left")
		Direction.RIGHT:
			print("right")
		Direction.UP:
			print("up")
		Direction.DOWN:
			print("down")
		_:
			print("none")

var random:RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()


static func get_children_in_group(node:Node, group:String) -> Array:
	var children:Array = []
	for child in node.get_children():
		if child.is_in_group(group):
			children.append(child)
		
		# Recursively search children
		children += get_children_in_group(child, group)
	return children


func disable_camera_drag() -> void:
#	var camera = get_tree().current_scene.get_node_or_null("Camera")
	var camera = get_tree().current_scene.find_node("Camera")
	if camera:
		camera.dragging_disabled = true


func enable_camera_drag() -> void:
#	var camera = get_tree().current_scene.get_node_or_null("Camera")
	var camera = get_tree().current_scene.find_node("Camera")
	if camera:
		camera.dragging_disabled = false


func scroll_camera(delta:Vector2) -> void:
	var camera = get_tree().current_scene.find_node("Camera")
	if camera:
		camera.position += delta


static func is_within_control(point:Vector2, node:Control) -> bool:
	var node_rect:Rect2 = Rect2(node.rect_global_position, node.rect_size)
	return node_rect.has_point(point)


static func get_true_event_position(node:Node, event:InputEvent) -> Vector2:
	return node.to_global(node.get_parent().make_canvas_position_local(event.position))


""" get_array_from_dict
	
	Returns an array of all items in the dictionary
	recursively to break up nested dictionaries
"""
static func get_array_from_dict(dict:Dictionary) -> Array:
	var new_array:Array = []
	for key in dict.keys():
		if dict[key] is Dictionary:
			new_array.append_array(get_array_from_dict(dict[key]))
		elif dict[key] is Array:
			new_array.append_array(dict[key])
		else:
			new_array.append(dict[key])
	return new_array


func set_mouse_filter_of_children(node:Node, filter:int) -> void:
	if node is Control:
		node.mouse_filter = filter
	for child in node.get_children():
		set_mouse_filter_of_children(child, filter)


func get_map_coords(position:Vector2) -> Vector2:
	var base_map:TileMap = get_tree().current_scene.find_node("BaseMap")
	if base_map:	
		return base_map.world_to_map(position)
	else:
		return Vector2.ZERO

func get_main_viewport() -> Viewport:
	var main_viewport:Viewport = get_tree().current_scene.find_node("MainViewport")
	return main_viewport


func to_inner_viewport_local(position_value:Vector2) -> Vector2:
	var viewport_container = get_tree().current_scene.find_node("ViewportContainer")
	var viewport_camera = viewport_container.find_node("Camera")
	
	if viewport_container and viewport_camera:
		var stretch_shrink = viewport_container.stretch_shrink
		position_value = (position_value - viewport_camera.get_camera_position()) / stretch_shrink
		
	return position_value


func to_outer_viewport_local(position_value:Vector2) -> Vector2:
	var viewport_container = get_tree().current_scene.find_node("ViewportContainer")
	var viewport_camera = viewport_container.find_node("Camera")
	
	if viewport_container and viewport_camera:
		var stretch_shrink = viewport_container.stretch_shrink
		position_value = (position_value - viewport_camera.get_camera_position()) * stretch_shrink
	
	return position_value
