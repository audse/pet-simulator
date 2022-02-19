extends Node2D

signal drag_released(from_pos, to_pos)

export (Vector2) var size:Vector2 setget set_area_size, get_area_size

export (bool) var snap_to_grid:bool = true
export (Vector2) var grid_size:Vector2 = Vector2(24, 24)
export (Vector2) var grid_offset:Vector2

onready var nodes:Dictionary = {
	panel = $DragRect,
	drag = $DragRect/Drag,
	animation_player = $DragRect/AnimationPlayer,
	hand_icon = $DragRect/HandIcon,
	buffer = $DragRect/BackBufferCopy,
	tween = $DragRect/Tween,
}

var is_scaled:bool = false
var time_since_last_drag:float = 0.0
var prev_mouse_position:Vector2 = Vector2.ZERO

#var parent_handler

func _ready() -> void:
	nodes.drag.connect("drag_released", self, "_on_drag_released")
	yield(Timers.wait(0.5), "completed")
	enter()


func _process(delta: float) -> void:
	if not nodes.drag.is_dragging:
		time_since_last_drag += delta
	
	if time_since_last_drag > 3.0 and not nodes.hand_icon.visible:
		show_hand_icon()


func _input(event:InputEvent) -> void:
	if nodes.drag.is_dragging:
		
		if not is_scaled:
			scale_up()
		
		time_since_last_drag = 0.0
		if nodes.hand_icon.visible:
			hide_hand_icon()
		
		if prev_mouse_position != Vector2.ZERO:
			var delta:Vector2 = event.position - prev_mouse_position
			global_position += delta
		prev_mouse_position = event.position
	else:
		prev_mouse_position = Vector2.ZERO


func enter() -> void:
	nodes.animation_player.play("Enter")
	nodes.animation_player.queue("Float")


func set_area_size(new_size:Vector2) -> void:
	if nodes:
		nodes.panel.rect_size = new_size
		nodes.drag.TouchAreaShape.size = new_size
		nodes.buffer.rect = Rect2(0, 0, new_size.x, new_size.y)


func get_area_size() -> Vector2:
	return size


func hide_hand_icon() -> void:
	nodes.animation_player.play("HideHand")
	yield(nodes.animation_player, "animation_finished")
	nodes.hand_icon.visible = false


func scale_up() -> void:
	is_scaled = true
	nodes.tween.interpolate_property(
		nodes.panel,
		"rect_scale",
		nodes.panel.rect_scale,
		Vector2(1.3, 1.3),
		0.25,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN
	)
	nodes.tween.start()


func reset_scale() -> void:
	is_scaled = false
	nodes.tween.interpolate_property(
		nodes.panel,
		"rect_scale",
		nodes.panel.rect_scale,
		Vector2(1, 1),
		0.25,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	nodes.tween.start()


func show_hand_icon() -> void:
	nodes.hand_icon.visible = true
	nodes.animation_player.play("HideHand", 0.5, -0.75, true)
	yield(nodes.animation_player, "animation_finished")
	nodes.animation_player.play("Float", 0.5)


func _on_drag_released(from_pos:Vector2, to_pos:Vector2) -> void:
	emit_signal("drag_released", from_pos, to_pos)
	reset_scale()
	
	if snap_to_grid:
		global_position = (to_pos - nodes.panel.rect_size / 2).snapped(grid_size)
