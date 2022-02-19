class_name PetInfoRenderer
extends Control


var data:PetData setget set_data, get_data

onready var components:Dictionary = {
	needs = find_node("NeedsRenderer"),
	personality = find_node("PersonalityRenderer"),
}

onready var nodes:Dictionary = {
	tween = $Tween
}

var queue:Queue = Queue.new()

var visible_y:float
var hidden_y:float


func _ready() -> void:
	
	visible = false
	modulate.a = 0
	
	queue.setup(self)
	
	yield(get_tree(), "idle_frame")
	
	visible_y = rect_position.y
	hidden_y = rect_position.y + (rect_size.y / 4)
	
#	yield(Timers.wait(0.5), "completed")
#	queue_enter()
#	queue_exit()


func set_data(data_value:PetData) -> void:
	data = data_value
	components.needs.data = data.needs_data
	components.personality.data = data.personality_data


func get_data() -> PetData:
	return data


func queue_enter() -> void:
	queue.add_func("enter", [], true)


func queue_exit() -> void:
	queue.add_func("exit", [], true)


func enter() -> void:
	visible = true
	modulate.a = 0
	yield(get_tree(), "idle_frame")
	nodes.tween.interpolate_property(
		self,
		"rect_position:y",
		hidden_y,
		visible_y,
		0.5,
		Tween.TRANS_CIRC,
		Tween.EASE_OUT
	)
	nodes.tween.interpolate_property(
		self,
		"rect_scale:y",
		1.2,
		1.0,
		0.5,
		Tween.TRANS_CIRC,
		Tween.EASE_OUT
	)
	nodes.tween.interpolate_property(
		self,
		"modulate:a",
		0,
		1,
		0.2,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	nodes.tween.start()
	yield(nodes.tween, "tween_all_completed")
	


func exit() -> void:
	visible = true
	yield(get_tree(), "idle_frame")
	nodes.tween.interpolate_property(
		self,
		"rect_position:y",
		visible_y,
		hidden_y,
		0.4,
		Tween.TRANS_CIRC,
		Tween.EASE_IN
	)
	nodes.tween.start()
	yield(Timers.wait(0.2), "completed")
	nodes.tween.interpolate_property(
		self,
		"modulate:a",
		1,
		0,
		0.2,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
	)
	nodes.tween.interpolate_property(
		self,
		"rect_scale:y",
		1.0,
		1.2,
		0.2,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	yield(nodes.tween, "tween_all_completed")
