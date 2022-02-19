class_name ActionGroupRenderer
extends Control

var _connect

""" ActionGroupRenderer
	Renders a set of action buttons in a circle surrounding the center
	- create with an Array<Dictionary> in the following format:
		[
			{
				id = "action_id_string",
				text = "Button text"
			},
			...
		]
"""

export (Font) var button_font
export (Color) var button_color
export (Color) var button_disabled_color
export (StyleBox) var button_normal
export (StyleBox) var button_pressed
export (StyleBox) var button_disabled
export (StyleBox) var button_focus

export (StyleBox) var cancel_button_normal
export (StyleBox) var cancel_button_pressed
export (StyleBox) var cancel_button_disabled
export (StyleBox) var cancel_button_focus
export (Color) var cancel_button_color
export (Color) var cancel_button_disabled_color

export (bool) var include_cancel_button

var pop_button_script:Script = preload("res://Nodes/Control/PopButton/pop_button.gd")

onready var nodes:Dictionary = {
	container = $ActionGroupContainer,
	button_group = PopButtonGroup.new(),
	tween = $Tween,
	cancel_button = $CancelButton
}

var data:PetData


func _ready() -> void:
	nodes.button_group.hide_on_start = true
	
#	yield(Timers.wait(1), "completed")
#	var actions:Array = ["Go eat!", "Go sleep!", "Go play!", "Go run!", "Go clean up!"]
#	draw(actions)
#
#	yield(Timers.wait(3), "completed")
#	clear()


func draw(actions:Array) -> void:
	for button in nodes.container.get_children():
		button.queue_free()
	
	for action in actions:
		create_action_button(action)
	
	if include_cancel_button:
		create_action_button({ id = "cancel", text = "" }, true)
	
	nodes.button_group.setup(nodes.container.get_children())
	nodes.button_group.queue_enter()
	
	nodes.tween.interpolate_property(
		nodes.container,
		"extra_margin",
		nodes.container.extra_margin * 8,
		nodes.container.extra_margin,
		0.5,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	nodes.tween.start()


func clear() -> void:
	nodes.button_group.queue_exit()
	yield(nodes.button_group, "buttons_exited")
	for button in nodes.container.get_children():
		button.queue_free()


func create_action_button(action:Dictionary, is_cancel_button:bool=false) -> void:
	if action.has_all(["id", "text"]):
		var action_button:Button = Button.new()
		action_button.set_script(pop_button_script)
		
		action_button.text = action.text
		action_button.hide_on_start = true
		
		var styles:Dictionary = {
			normal = {
				stylebox = button_normal if not is_cancel_button else cancel_button_normal,
				color = button_color if not is_cancel_button else cancel_button_color,
			},
			hover = {
				stylebox = button_normal if not is_cancel_button else cancel_button_normal,
				color = button_color if not is_cancel_button else cancel_button_color,
			},
			pressed = {
				stylebox = button_pressed if not is_cancel_button else cancel_button_pressed,
				color = button_color if not is_cancel_button else cancel_button_color,
			},
			disabled = {
				stylebox = button_disabled if not is_cancel_button else cancel_button_disabled,
				color = button_disabled_color if not is_cancel_button else cancel_button_disabled_color
			},
			focus = {
				stylebox = button_focus if not is_cancel_button else cancel_button_focus,
				color = button_color if not is_cancel_button else cancel_button_color,
			}
		}
		
		if is_cancel_button:
			action_button = nodes.cancel_button.duplicate()
			action_button.get_node("TextureRect").modulate = button_color
		
		for key in styles.keys():
			action_button.add_stylebox_override(key, styles[key].stylebox)
			action_button.add_color_override(key, styles[key].color)
			
		action_button.add_font_override("font", button_font)
		
		nodes.container.add_child(action_button)
		action_button.set_meta("id", action.id)
		
		if is_cancel_button:
			_connect = action_button.connect("pressed", self, "clear")
		else:
			_connect = action_button.connect("pressed", self, "emit_action", [action])


func get_button(action_text:String) -> Button:
	for button in nodes.container.get_children():
		if button is Button and button.text == action_text:
			return button
	return Button.new()


func emit_action(action:Dictionary) -> void:
	if action.has("id") and data and data.action_data:
		data.action_data.emit_signal("action_selected", action.id)


func get_buttons() -> Array:
	return nodes.container.get_children()
