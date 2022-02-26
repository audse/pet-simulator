class_name State extends Node

signal exit_state(prev_state)
signal enter_state(next_state)

"""
	state_change_delay
	yields a certain amount of time before
	switching states, to give time for 
	animations/etc. to complete
"""
var state_change_delay:float = 0
var target_node:Node = null
var reset_state:int = 0

var state:int = reset_state


func _init(state_value:int=0, reset_state_value=null) -> void:
	state = state_value
	if reset_state_value != null:
		reset_state = reset_state_value
	else:
		reset_state = state_value


func reset() -> void:
	if state != reset_state:
		set_to(reset_state)


func enter(next_state:int) -> void:
	state = next_state
	emit_signal("enter_state", next_state)


func exit() -> void:
	emit_signal("exit_state", state)


func set_to(next_state:int, yield_time:float=state_change_delay) -> void:
	if state != next_state:
		exit()
		yield(Timers.wait(yield_time), "completed")
		enter(next_state)
