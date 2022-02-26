class_name Modal
extends Control

signal modal_entered(node)
signal modal_exited(node)
var _connect

export (NodePath) var target_node_path
export (NodePath) var modal_node_path
export (Color) var overlay_color = Color(0, 0, 0, 0.25)
export (float) var overlay_blur_amount = 1.0

var target_node:Control
var modal_node:Control

var queue:Queue = Queue.new(self, true, false)
var tween:Tween = Tween.new()
var overlay_rect:ColorRect = ColorRect.new()
var blur_rect:ColorRect = ColorRect.new()

var visible_y:float
var hidden_y:float

var is_open:bool = false


func _ready() -> void:
	
	if target_node_path:
		target_node = get_node(target_node_path)
	else:
		target_node = get_parent_control()
	
	if modal_node_path:
		modal_node = get_node(modal_node_path)
	
	target_node.visible = false
	target_node.modulate.a = 0
	blur_rect.visible = false
	blur_rect.modulate.a = 0
	overlay_rect.visible = false
	overlay_rect.modulate.a = 0
	
	set_anchors_preset(Control.PRESET_WIDE)
	overlay_rect.set_anchors_preset(Control.PRESET_WIDE)
	overlay_rect.color = overlay_color
	
	blur_rect.set_anchors_preset(Control.PRESET_WIDE)
	blur_rect.material = ShaderMaterial.new()
	blur_rect.material.shader = load("res://Assets/Shaders/Blur/blur.gdshader")
	blur_rect.material.set_shader_param("blur_amount", overlay_blur_amount)
	
	add_child(queue)
	add_child(tween)
	add_child(blur_rect)
	add_child(overlay_rect)
	
	yield(get_tree(), "idle_frame")
	
	visible_y = target_node.rect_position.y
	hidden_y = target_node.rect_position.y + (target_node.rect_size.y / 4)


func _input(event: InputEvent) -> void:
	if (
		event is InputEventScreenTouch 
		and event.is_pressed() 
		and not event.is_echo() 
		and is_open
		and modal_node_path
		and not modal_node.get_rect().has_point(event.position)
	):
		queue_exit()


func queue_toggle() -> void:
	if is_open:
		queue_exit()
	else:
		queue_enter()


func queue_enter() -> void:
	queue.add_func("enter", [], true)


func queue_exit() -> void:
	yield(Timers.wait(0.1), "completed")
	queue.add_func("exit", [], true)


func enter() -> void:
	if not is_open:
		is_open = true
		
		target_node.visible = true
		target_node.modulate.a = 0
		
		blur_rect.visible = true
		blur_rect.modulate.a = 0
		
		overlay_rect.visible = true
		overlay_rect.modulate.a = 0
		
		yield(get_tree(), "idle_frame")
		
		tween.interpolate_property(
			blur_rect,
			"modulate:a",
			0,
			1,
			0.5,
			Tween.TRANS_QUAD,
			Tween.EASE_OUT
		)
		tween.interpolate_property(
			overlay_rect,
			"modulate:a",
			0,
			1,
			0.5,
			Tween.TRANS_QUAD,
			Tween.EASE_OUT
		)
		
		tween.interpolate_property(
			target_node,
			"rect_position:y",
			hidden_y,
			visible_y,
			0.5,
			Tween.TRANS_CIRC,
			Tween.EASE_OUT
		)
		tween.interpolate_property(
			target_node,
			"rect_scale:y",
			1.2,
			1.0,
			0.5,
			Tween.TRANS_CIRC,
			Tween.EASE_OUT
		)
		tween.interpolate_property(
			target_node,
			"modulate:a",
			0,
			1,
			0.2,
			Tween.TRANS_QUAD,
			Tween.EASE_OUT
		)
		tween.start()
		yield(tween, "tween_all_completed")
		
		emit_signal("modal_entered", self)
	yield(get_tree(), "idle_frame")


func exit() -> void:	
	if is_open:
		is_open = false

		target_node.visible = true
		yield(get_tree(), "idle_frame")

		tween.interpolate_property(
			blur_rect,
			"modulate:a",
			1,
			0,
			0.5,
			Tween.TRANS_QUAD,
			Tween.EASE_OUT
		)
		tween.interpolate_property(
			overlay_rect,
			"modulate:a",
			1,
			0,
			0.5,
			Tween.TRANS_QUAD,
			Tween.EASE_OUT
		)

		tween.interpolate_property(
			target_node,
			"rect_position:y",
			visible_y,
			hidden_y,
			0.4,
			Tween.TRANS_CIRC,
			Tween.EASE_IN
		)
		tween.start()
		yield(Timers.wait(0.2), "completed")
		tween.interpolate_property(
			target_node,
			"modulate:a",
			1,
			0,
			0.2,
			Tween.TRANS_QUAD,
			Tween.EASE_IN
		)
		tween.interpolate_property(
			target_node,
			"rect_scale:y",
			1.0,
			1.2,
			0.2,
			Tween.TRANS_QUAD,
			Tween.EASE_OUT
		)
		yield(tween, "tween_all_completed")

		emit_signal("modal_exited", target_node)

		target_node.visible = false
		target_node.modulate.a = 0
		blur_rect.visible = false
		blur_rect.modulate.a = 0
		overlay_rect.visible = false
		overlay_rect.modulate.a = 0
	yield(get_tree(), "idle_frame")
