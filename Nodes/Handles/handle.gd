class_name Handle
extends AnimatedSprite

signal handle_drag_started(from_pos, node)
signal handle_drag_released(from_pos, to_pos, node)
var _connect

var start_position:Vector2 = Vector2.ZERO

# sprite options
var sprite_offset:Vector2 = Vector2(0, 0)
var start_frame:int = 0

# modulate options
var start_modulate:Color = Color("#ffffff")
var fade_alpha:float = 0.25
var active_modulate:Color = Color("#d23843")

# drag options
var drag_args:Dictionary = {}

# tilemap options
var snap_on_release:bool = false
var snap_tile_size:Vector2 = Vector2.ZERO

var nodes:Dictionary = {
	drag = null
}

var prev_mouse_position:Vector2 = Vector2.ZERO


func _init(args:Dictionary={}) -> void:
	match args:
		{ "start_position", ..}:
			start_position = args.start_position
			continue
		
		# sprite options
		{ "sprite_offset", ..}:
			sprite_offset = args.sprite_offset
			continue
		{ "frames", ..}:
			frames = args.frames
			continue
		{ "start_frame", ..}:
			start_frame = args.start_frame
			continue
		
		# drag options
		{ "drag_args", ..}:
			drag_args = args.drag_args
			continue
		
		# modulate options
		{ "start_modulate", ..}:
			start_modulate = args.start_modulate
			self_modulate = args.start_modulate
			continue
		{ "fade_alpha", ..}:
			fade_alpha = args.fade_alpha
			continue
		{ "active_modulate", ..}:
			active_modulate = args.active_modulate
			continue
		
		# tilemap options
		{ "snap_on_release", ..}:
			snap_on_release = args.snap_on_release
			continue
		{ "snap_tile_size", ..}:
			snap_tile_size = args.snap_tile_size
			continue


func _enter_tree() -> void:
	global_position = start_position + sprite_offset
	
	add_to_group("handle")
	
	# Create drag node
	nodes.drag = make_draggable()
	
	# play animation
	if frames and frames.has_animation("default"):
		play("default")


func make_draggable() -> Draggable:
	# set of drag area to size of handle
	if not drag_args.has("touch_area_shape"):
		var texture_size:Vector2 = get_texture_size()
		drag_args.touch_area_shape = Rect2(
			-texture_size / 2,
			texture_size
		)
	
	var new_drag:Draggable = Draggable.new(self, drag_args)
	add_child(new_drag)
	
	_connect = new_drag.connect("drag_started", self, "handle_drag_started")
	_connect = new_drag.connect("drag_released", self, "handle_drag_released")
	
	return new_drag


func get_texture_size() -> Vector2:
	if frames and frames.has_animation("default"):
		var first_frame = frames.get_frame("default", 0)
		if first_frame:
			return first_frame.get_size()
	return Vector2.ZERO
	

func tween_to_position(new_position:Vector2, time:float=0.25) -> void:
	yield(
		Tweens.tween(
			self,
			"global_position",
			global_position,
			new_position + sprite_offset,
			time
		), 
		"completed"
	)


func enable() -> void:
	if nodes.drag:
		nodes.drag.disabled = false
	yield(fade_in(), "completed")


func disable() -> void:
	if nodes.drag:
		nodes.drag.disabled = true
	yield(fade(), "completed")


func delete(to_fade_out:bool) -> void:
	if to_fade_out:
		yield(fade_out(), "completed")
	call_deferred("queue_free")


func fade() -> void:
	yield(
		Tweens.tween(self, "modulate:a", modulate.a, start_modulate.a, fade_alpha, 0.15), 
		"completed"
	)


func fade_in() -> void:
	yield(
		Tweens.tween(self, "modulate:a", modulate.a, start_modulate.a, 0.15), 
		"completed"
	)


func fade_out() -> void:
	yield(
		Tweens.tween(self, "modulate:a", modulate.a, 0, 0.15), 
		"completed"
	)


func handle_drag_started(from_pos:Vector2) -> void:
	self_modulate = active_modulate
	emit_signal("handle_drag_started", from_pos, self)


func handle_drag_released(from_pos:Vector2, to_pos:Vector2) -> void:
	if snap_on_release and snap_tile_size:
		global_position = global_position.snapped(snap_tile_size - (sprite_offset / 2))
	self_modulate = start_modulate
	emit_signal("handle_drag_released", from_pos, to_pos, self)
