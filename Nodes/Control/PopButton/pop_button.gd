class_name PopButton
extends BaseButton

signal button_entered(node)
signal button_exited(node)
signal button_popped(node)
signal button_entered_hover(node)
signal button_exited_hover(node)
signal button_activated(node)
signal button_deactivated(node)
var _connect

export (bool) var hide_on_start:bool = false
export (bool) var pop_on_pressed:bool = true
export (bool) var pop_on_hover:bool = true
export (float) var time:float = 0.5
export (bool) var logging_enabled:bool = false
export(Dictionary) var modulate_options:Dictionary = {
	active = Color("#ffffff"),
	inactive = Color("#e4e9ec")
}

var queue:Queue

func _ready() -> void:
	if hide_on_start:
		modulate.a = 0
		visible = false
	if pop_on_pressed:
		_connect = connect("pressed", self, "queue_pop")
	
	if pop_on_hover:
		_connect = connect("mouse_entered", self, "queue_enter_hover")
		_connect = connect("mouse_exited", self, "queue_exit_hover")
	
	queue = Queue.new(self, true, logging_enabled)
	add_child(queue)


func queue_hide() -> void:
	queue.add_func("hide", [], false)


func hide() -> void:
	modulate.a = 0
	visible = false


func queue_enter(delay:float=0) -> void:
	queue.add_func("enter", [delay], true)


func enter(delay:float=0) -> void:
	modulate.a = 0
	visible = true
	yield(Tweens.pop_in_control_node(self, delay, time), "completed")
	
	emit_signal("button_entered", self)


func queue_exit(delay:float=0, is_group:bool=false) -> void:
	queue.add_func("exit", [delay, is_group], true)


func exit(delay:float=0, is_group:bool=false) -> void:
	yield(Tweens.pop_out_control_node(self, delay, time), "completed")
	if not is_group:
		visible = false
		modulate.a = 0
	
	emit_signal("button_exited", self)


func queue_pop() -> void:
	queue.add_func("pop", [], true)


func pop() -> void:
	yield(Tweens.pop_control_node(self, time / 2), "completed")
	emit_signal("button_popped", self)


func queue_enter_hover() -> void:
	if not disabled:
		queue.remove_func("enter_hover")
		queue.add_func("enter_hover", [], true)


func enter_hover() -> void:
	rect_pivot_offset = rect_size / 2
	yield(Tweens.tween(
		self,
		"rect_scale",
		rect_scale,
		Vector2(1.05, 1.05),
		0.15
	), "completed")
	emit_signal("button_entered_hover", self)


func queue_exit_hover() -> void:
	if not disabled:
		queue.add_func("exit_hover", [], true)


func exit_hover() -> void:
	yield(Tweens.tween(
		self,
		"rect_scale",
		rect_scale,
		Vector2.ONE,
		0.15
	), "completed")
	emit_signal("button_exited_hover", self)


func queue_activate(delay:float=0) -> void:
	queue.add_func("activate", [delay], true)


func activate(delay:float=0) -> void:
	yield(Tweens.delay_tween(
		self,
		"modulate",
		modulate,
		modulate_options.active,
		time,
		delay
	), "completed")
	
	emit_signal("button_activated", self)
	

func queue_deactivate(delay:float=0) -> void:
	queue.add_func("deactivate", [delay], true)
	

func deactivate(delay:float=0) -> void:
	yield(Tweens.delay_tween(
		self,
		"modulate",
		modulate,
		modulate_options.inactive,
		time,
		delay
	), "completed")
	
	emit_signal("button_deactivated", self)


func queue_swap_text(new_text:String, delay:float=0) -> void:
	queue.add_func("swap_text", [new_text, delay], true)


func swap_text(new_text:String, delay:float=0) -> void:
	yield(Timers.wait(delay), "completed")
	if "text" in self:
		# warning-ignore:unsafe_property_access
		self.text = new_text
