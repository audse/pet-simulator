class_name PopButton
extends BaseButton

signal button_entered
signal button_exited
signal button_popped
signal button_activated
signal button_deactivated
var _connect

export (bool) var hide_on_start:bool = false
export (bool) var pop_on_pressed:bool = true
export (float) var time:float = 0.5
export(Dictionary) var modulate_options:Dictionary = {
	active = Color("#ffffff"),
	inactive = Color("#e4e9ec")
}

onready var queue:Queue = Queue.new()

func _ready() -> void:
	if hide_on_start:
		modulate.a = 0
		visible = false
	if pop_on_pressed:
		_connect = connect("pressed", self, "queue_pop")
	queue.setup(self)

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
	
	emit_signal("button_entered")


func queue_exit(delay:float=0, is_group:bool=false) -> void:
	queue.add_func("exit", [delay, is_group], true)


func exit(delay:float=0, is_group:bool=false) -> void:
	yield(Tweens.pop_out_control_node(self, delay, time), "completed")
	if not is_group:
		visible = false
		modulate.a = 0
	
	emit_signal("button_exited")


func queue_pop() -> void:
	queue.add_func("pop", [], true)


func pop() -> void:
	yield(Tweens.pop_control_node(self, time / 2), "completed")
	emit_signal("button_popped")


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
	
	emit_signal("button_activated")
	

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
	
	emit_signal("button_deactivated")


func queue_swap_text(new_text:String, delay:float=0) -> void:
	queue.add_func("swap_text", [new_text, delay], true)


func swap_text(new_text:String, delay:float=0) -> void:
	yield(Timers.wait(delay), "completed")
	if "text" in self:
		self.text = new_text
