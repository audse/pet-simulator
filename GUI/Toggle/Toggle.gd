extends CheckButton

func _on_toggled(toggled) -> void:
	_tween_icon($IconOff, toggled)
	_tween_icon($IconOn, toggled)

func manually_toggle(toggled) -> void:
	_tween_icon($IconOff, toggled)
	_tween_icon($IconOn, toggled)

func _tween_icon(node:Sprite, toggled:bool) -> void:
	
	var time = 0.15
	var target:Dictionary = {
		position = (
			Vector2(17, 7)
			if toggled
			else Vector2(7, 7)
		),
		alpha = (
			0.0
			if (node == $IconOff and toggled) or (node == $IconOn and not toggled)
			else 1.0
		),
		ease_type = (
			Tween.EASE_IN
			if (node == $IconOff and toggled) or (node == $IconOn and not toggled)
			else Tween.EASE_OUT
		),
		red = (
			0.9
			if toggled
			else 1.0
		),
		blue = (
			0.8
			if toggled
			else 1.0
		)
	}
	
	$Tween.interpolate_property(
		node,
		"position",
		node.position,
		target.position,
		time,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property(
		node,
		"modulate:a",
		node.modulate.a,
		target.alpha,
		time,
		Tween.TRANS_CUBIC,
		target.ease_type
	)
	$Tween.interpolate_property(
		self,
		"modulate:r",
		self.modulate.r,
		target.red,
		time,
		Tween.TRANS_CUBIC,
		target.ease_type
	)
	$Tween.interpolate_property(
		self,
		"modulate:b",
		self.modulate.b,
		target.blue,
		time,
		Tween.TRANS_CUBIC,
		target.ease_type
	)
	$Tween.start()
