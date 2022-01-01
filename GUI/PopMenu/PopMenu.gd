extends Panel

var expanded = false

func _ready():
	yield(get_tree(), "idle_frame")
	self.rect_scale = Vector2(0, 0)

func show():
	expanded = true
	$Tween.interpolate_property(
		self,
		"rect_scale",
		self.rect_scale,
		Vector2(1.1, 1.1),
		0.25,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN_OUT
	)
	
	$Tween.start()
	yield($Tween, "tween_completed")
	
	$Tween.interpolate_property(
		self,
		"rect_scale",
		self.rect_scale,
		Vector2(1, 1),
		0.25,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	$Tween.start()

func hide():
	expanded = false
	$Tween.interpolate_property(
		self,
		"rect_scale",
		self.rect_scale,
		self.rect_scale * 1.05,
		0.25,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN_OUT
	)
	
	$Tween.start()
	yield($Tween, "tween_completed")
	
	$Tween.interpolate_property(
		self,
		"rect_scale",
		self.rect_scale,
		Vector2(0, 0),
		0.25,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN
	)
	$Tween.start()
	
