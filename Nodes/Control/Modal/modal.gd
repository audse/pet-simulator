class_name Modal
extends PanelContainer

signal modal_entered
signal modal_exited

onready var Nodes = {
	BlurRect = $BlurRect,
	Panel = $Margin/Panel,
	Margin = $Margin,
	TapArea = $TapArea,
}
onready var queue = Queue.new()

var panel_positions:Dictionary = {
	show = null,
	hide = null,
}

func _ready():
	queue.setup(self)
	visible = false
	modulate.a = 0
	
	yield(get_tree(), "idle_frame")
	panel_positions.show = Nodes.Margin.rect_position
	panel_positions.hide = Vector2(
		Nodes.Margin.rect_position.x,
		Nodes.Margin.rect_position.y + get_viewport_rect().size.y
	)


func queue_enter(delay:float=0):
	queue.add_func("enter", [delay], true)


func enter(delay:float=0):
	yield(Timers.wait(delay), "completed")
	modulate.a = 0
	visible = true
	Nodes.Margin.rect_position = panel_positions.hide
	Tweens.tween(
		self,
		"modulate:a",
		modulate.a,
		1,
		0.4,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	Tweens.tween(
		Nodes.BlurRect,
		"self_modulate:a",
		Nodes.BlurRect.self_modulate.a,
		1,
		0.75,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	yield(Tweens.tween(
		Nodes.Margin,
		"rect_position",
		Nodes.Margin.rect_position,
		panel_positions.show,
		0.4,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	), "completed")
	emit_signal("modal_entered")


func queue_exit(delay:float=0) -> void:
	queue.add_func("exit", [delay], true)


func exit(delay:float=0) -> void:
	yield(Timers.wait(delay), "completed")
	Tweens.tween(
		self,
		"modulate:a",
		modulate.a,
		0,
		0.4,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN
	)
	yield(Tweens.tween(
		Nodes.Margin,
		"rect_position",
		Nodes.Margin.rect_position,
		panel_positions.hide,
		0.4,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN
	), "completed")
	modulate.a = 0
	visible = false
	emit_signal("modal_exited")


func _on_TapArea_pressed():
	queue_exit()
