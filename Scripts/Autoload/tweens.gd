extends Node

func tween(
		node,
		property_name:String,
		start_value,
		target_value,
		time:float=1,
		trans_type:int=Tween.TRANS_CUBIC,
		ease_type:int=Tween.EASE_IN_OUT
	) -> void:
		
	var tween = Tween.new()
	node.add_child(tween)
	
	tween.interpolate_property(
			node,
			property_name,
			start_value,
			target_value,
			time,
			trans_type,
			ease_type
		)
	tween.start()
	yield(tween, "tween_completed")
	
	if is_instance_valid(tween):
		tween.queue_free()
	
func delay_tween(
		node,
		property_name:String,
		start_value,
		target_value,
		time:float=1,
		delay_time:float=1,
		trans_type:int=Tween.TRANS_CUBIC,
		ease_type:int=Tween.EASE_IN_OUT
	) -> void:
		
	var tween = Tween.new()
	node.add_child(tween)
	
	tween.interpolate_property(
			node,
			property_name,
			start_value,
			target_value,
			time,
			trans_type,
			ease_type
		)
	yield(Timers.wait(delay_time), "completed")
	if is_instance_valid(tween):
		tween.start()
		yield(tween, "tween_completed")
		tween.queue_free()


func tween_material(
		node,
		property_name:String,
		start_value,
		target_value,
		time:float=1,
		trans_type:int=Tween.TRANS_CUBIC,
		ease_type:int=Tween.EASE_IN_OUT
	) -> void:
		
	var tween = Tween.new()
	node.add_child(tween)
	
	tween.interpolate_property(
			node.get_material(),
			property_name,
			start_value,
			target_value,
			time,
			trans_type,
			ease_type
		)
	tween.start()
	yield(tween, "tween_completed")
	
	if is_instance_valid(tween):
		tween.queue_free()


func move(
		node,
		target_position:Vector2,
		time:float=1,
		trans_type:int=Tween.TRANS_LINEAR,
		ease_type:int=Tween.TRANS_LINEAR
	) -> void:
	
	var tween = Tween.new()
	node.add_child(tween)
	
	tween.interpolate_property(
			node,
			"global_position",
			node.global_position,
			target_position,
			time,
			trans_type,
			ease_type
		)
		
	tween.start()
	
	yield(tween, "tween_completed")
	tween.queue_free()
	
func pop_out(node, delay:float=0.1, time:float=0.5, pivot_offset=null) -> void:
	yield(Timers.wait(delay), "completed")
	node.rect_pivot_offset = node.rect_size / 2 if not pivot_offset else pivot_offset
	yield(Tweens.tween(
			node,
			"rect_scale",
			node.rect_scale,
			Vector2(1.1, 1.1),
			time / 2
		), "completed")
	yield(Tweens.tween(
			node,
			"rect_scale",
			node.rect_scale,
			Vector2(0, 0),
			time / 2
		), "completed")
	node.modulate.a = 0

func pop_in(node, delay:float=0, time:float=0.5, pivot_offset=null) -> void:
	node.rect_scale = Vector2(1, 1)
	node.rect_pivot_offset = node.rect_size / 2 if not pivot_offset else pivot_offset
	yield(get_tree(), "idle_frame")
	node.rect_scale = Vector2(0, 0)
	yield(Timers.wait(delay), "completed")
	node.modulate.a = 1
	yield(Tweens.tween(
			node,
			"rect_scale",
			Vector2(0, 0),
			Vector2(1.1, 1.1),
			time / 2
		), "completed")
	yield(Tweens.tween(
			node,
			"rect_scale",
			node.rect_scale,
			Vector2(1, 1),
			time / 2
		), "completed")
		
func pop_in_control_node(node, delay:float=0, time:float=0.5, pivot_offset=null) -> void:
	node.rect_scale = Vector2(1, 1)
	node.rect_pivot_offset = node.rect_size / 2 if not pivot_offset else pivot_offset
	yield(get_tree(), "idle_frame")
	node.rect_scale = Vector2(0, 0)
	yield(Timers.wait(delay), "completed")
	node.modulate.a = 1
	yield(Tweens.tween(
			node,
			"rect_scale",
			Vector2(0, 0),
			Vector2(1.1, 1.1),
			time / 2
		), "completed")
	yield(Tweens.tween(
			node,
			"rect_scale",
			node.rect_scale,
			Vector2(1, 1),
			time / 2
		), "completed")
		
func pop_out_control_node(node, delay:float=0.1, time:float=0.25, pivot_offset=null) -> void:
	yield(Timers.wait(delay), "completed")
	if is_instance_valid(node):
		node.rect_pivot_offset = node.rect_size / 2 if not pivot_offset else pivot_offset
		yield(Tweens.tween(
				node,
				"rect_scale",
				node.rect_scale,
				Vector2(1.1, 1.1),
				time / 2
			), "completed")
		yield(Tweens.tween(
				node,
				"rect_scale",
				node.rect_scale,
				Vector2(0, 0),
				time / 2
			), "completed")
		node.modulate.a = 0
	
func pop_control_node(node, time:float=0.25, pivot_offset=null) -> void:
	node.rect_pivot_offset = node.rect_size / 2 if not pivot_offset else pivot_offset
	yield(Tweens.tween(
			node,
			"rect_scale",
			node.rect_scale,
			Vector2(0.9, 0.9),
			time / 3
		), "completed")
	yield(Tweens.tween(
			node,
			"rect_scale",
			node.rect_scale,
			Vector2(1.1, 1.1),
			time / 2
		), "completed")
	yield(Tweens.tween(
			node,
			"rect_scale",
			node.rect_scale,
			Vector2(1, 1),
			time / 1
		), "completed")
