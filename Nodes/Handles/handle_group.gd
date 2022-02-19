class_name HandleGroup
extends Node2D

signal handle_drag_released(from_pos, to_pos, handle)
var _connect

#var base_map:TileMap = null
var current_handle = null


onready var args = {
	# sprite options
	frames = preload("res://Assets/Interface/Buttons/tres/bubble_button_sprite_frames.tres"),
	sprite_offset = Vector2(12, 12),
	
	# modulate options
	start_modulate = Color("#ffffff"),
	active_modulate = Color("#d23843"),
	fade_alpha = 0.15,
	
	# tilemap options
	snap_on_release = true,
	snap_tile_size = Vector2(24, 24),
}


func handle_drag_started(_from_pos:Vector2, handle:Handle) -> void:
	Globals.disable_camera_drag()
	
	disable_others_in_tree(handle)
	current_handle = handle


func handle_drag_released(from_pos:Vector2, to_pos:Vector2, handle:Handle) -> void:
	Globals.enable_camera_drag()
	
	enable_all_in_tree()
	
	current_handle = null
	emit_signal("handle_drag_released", from_pos, to_pos, handle)

			
func add_handle(extra_args:Dictionary) -> void:
	for arg_key in extra_args.keys():
		args[arg_key] = extra_args[arg_key]
		
	var new_handle:Handle = Handle.new(args)
	
	add_child(new_handle)
	_connect = new_handle.connect("handle_drag_started", self, "handle_drag_started")
	_connect = new_handle.connect("handle_drag_released", self, "handle_drag_released")


func delete_all(to_fade_out:bool=true) -> void:
	var last_handle:Handle = get_last_handle()
	for handle in get_children():
		if handle is Handle:
			if handle == last_handle:
				yield(handle.delete(to_fade_out), "completed")
			else:
				handle.delete(to_fade_out)
	yield(get_tree(), "idle_frame")


func enable_all() -> void:
	var last_handle:Handle = get_last_handle()
	for handle in get_children():
		if handle is Handle:
			if handle == last_handle:
				yield(handle.enable(), "completed")
			else:
				handle.enable()
	yield(get_tree(), "idle_frame")


func disable_all() -> void:
	var last_handle:Handle = get_last_handle()
	for handle in get_children():
		if handle is Handle:
			if handle == last_handle:
				yield(handle.disable(), "completed")
			else:
				handle.disable()
	yield(get_tree(), "idle_frame")


func enable_others(static_handle:AnimatedSprite) -> void:
	var last_handle:Handle = get_last_handle()
	for handle in get_children():
		if handle != static_handle and handle is Handle:
			if handle == last_handle:
				yield(handle.enable(), "completed")
			else:
				handle.enable()
	yield(get_tree(), "idle_frame")


func disable_others(static_handle:AnimatedSprite) -> void:
	var last_handle:Handle = get_last_handle()
	for handle in get_children():
		if handle != static_handle and handle is AnimatedSprite:
			if handle == last_handle:
				yield(handle.disable(), "completed")
			else:
				handle.disable()
	yield(get_tree(), "idle_frame")


# Disables every handle node in the entire scene tree
func disable_others_in_tree(static_handle:AnimatedSprite) -> void:
	var handles:Array = Globals.get_children_in_group(get_tree().current_scene, "handle")
	var last_handle:Handle = get_last_handle(handles)
	for handle in handles:
		if handle != static_handle and handle is AnimatedSprite:
			if handle == last_handle:
				yield(handle.disable(), "completed")
			else:
				handle.disable()
	yield(get_tree(), "idle_frame")


# Enables every handle node in the entire scene tree
func enable_all_in_tree() -> void:
	var handles:Array = Globals.get_children_in_group(get_tree().current_scene, "handle")
	var last_handle:Handle = get_last_handle(handles)
	for handle in handles:
		if handle is Handle:
			if handle == last_handle:
				yield(handle.enable(), "completed")
			else:
				handle.enable()
	yield(get_tree(), "idle_frame")


func get_last_handle(children:Array=get_children()) -> Handle:
	if len(children) > 0:
		for child in children:
			if child is Handle:
				return child
	return null
