class_name PopButtonGroup
extends Node

signal buttons_entered
signal buttons_exited
signal buttons_activated
signal buttons_deactivated
var _connect

export (bool) var hide_on_start:bool = false
export (bool) var pop_on_pressed:bool = true
export (bool) var exit_backwards:bool = true
export (float) var time:float = 0.5
export (float) var delay_increment:float = 0.1
export(Dictionary) var modulate_options:Dictionary = {
	active = Color("#ffffff"),
	inactive = Color("#e4e9ec")
}

var buttons:Array = []

func setup(group_buttons:Array) -> void:
	for button in group_buttons:
		if button is PopButton:
			buttons.append(button)
			button.time = time
			button.modulate_options = modulate_options
			if hide_on_start:
				button.hide_on_start = true
				button.hide()
			if pop_on_pressed:
				button.pop_on_pressed = true


func get(button_name:String):
	for button in buttons:
		if button.name == button_name:
			return button


func queue_enter(buttons_to_enter:Array=buttons) -> void:
	var delay:float = 0
	for button in buttons_to_enter:
		if button is PopButton:
			button.queue_enter(delay)
		delay += delay_increment


func enter(buttons_to_enter:Array=buttons) -> void:
	var delay:float = 0
	for button in buttons_to_enter:
		if button is PopButton:
			button.queue.add_func("enter", [delay], true)
		delay += delay_increment
		
	yield(Timers.wait(delay + time), "completed")
	emit_signal("buttons_entered")


func queue_exit(buttons_to_exit:Array=buttons) -> void:
	var delay:float = 0
	if exit_backwards:
		buttons_to_exit.invert()
	for button in buttons_to_exit:
		if button is PopButton:
			button.queue_exit(delay, true)
		delay += delay_increment
	
	if len(buttons_to_exit) > 0:
		var last_button:PopButton = buttons_to_exit[len(buttons_to_exit)-1]
		yield(last_button.queue, "all_complete")
		
		# If you hide the buttons as they exit, they
		# will flicker because the anchors will update
		# we need to hide them all at the same time
		hide(buttons_to_exit)
	else:
		yield(Timers.wait(), "completed")


func hide(buttons_to_hide:Array=buttons) -> void:
	for button in buttons_to_hide:
		if button is PopButton:
			button.hide()


func exit(buttons_to_exit:Array=buttons) -> void:
	var delay:float = 0
	if exit_backwards:
		buttons_to_exit.invert()
	for button in buttons_to_exit:
		if button is PopButton:
			button.exit(delay, true)
		delay += delay_increment
		
	yield(Timers.wait(delay + time), "completed")
	
	# If you hide the buttons as they exit, they
	# will flicker because the anchors will update
	# we need to hide them all at the same time
	for button in buttons_to_exit:
		if button is PopButton:
			button.hide()
	
	emit_signal("buttons_exited")


func activate(buttons_to_activate:Array=buttons) -> void:
	var delay:float = 0
	for button in buttons_to_activate:
		if button is PopButton:
			button.activate(delay)
		delay += delay_increment
		
	yield(Timers.wait(delay + time), "completed")
	emit_signal("buttons_activated")


func deactivate(buttons_to_deactivate:Array=buttons) -> void:
	var delay:float = 0
	for button in buttons_to_deactivate:
		if button is PopButton:
			button.deactivate(delay)
		delay += delay_increment
		
	yield(Timers.wait(delay + time), "completed")
	emit_signal("buttons_deactivated")
