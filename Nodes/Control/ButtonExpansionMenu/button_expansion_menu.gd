class_name ButtonExpansionMenu
extends Control

signal build_here_pressed
signal toggle_started(is_open)
signal toggle_finished(is_open)

export (bool) var is_open:bool = false
export (bool) var yield_before_animation:bool = false
var current_toggle_state

onready var nodes:Dictionary = {
	open_button = find_node("OpenButton"),
	close_button = find_node("CloseButton"),
	animation_player = $AnimationPlayer,
	content = find_node("ContentContainer"),
	menu = $MenuContainer,
	build_here_button = find_node("BuildHereButton")
}

func _ready() -> void:
	nodes.open_button.connect("pressed", self, "start_toggle")
	nodes.close_button.connect("pressed", self, "start_toggle")
	
	nodes.animation_player.play("RESET")
	
	if not is_open:
		set_mouse_filter_of_children(nodes.menu, Control.MOUSE_FILTER_IGNORE)


func start_toggle() -> void:
	current_toggle_state = toggle()


func toggle() -> void:
	if not is_open:
		is_open = true
		emit_signal("toggle_started", is_open)
		
		if yield_before_animation:
			yield()
		
		set_mouse_filter_of_children(nodes.menu, Control.MOUSE_FILTER_STOP)
		nodes.animation_player.queue("Open")
	
	else:
		is_open = false
		emit_signal("toggle_started", is_open)
		
#		if yield_before_animation:
#			yield()
		
		set_mouse_filter_of_children(nodes.menu, Control.MOUSE_FILTER_IGNORE)
		nodes.animation_player.play_backwards("Open")
	
	yield(nodes.animation_player, "animation_finished")
	emit_signal("toggle_finished", is_open)


func set_mouse_filter_of_children(node:Node, filter:int) -> void:
	if node is Button:
		(node as Button).mouse_filter = filter
	for child in node.get_children():
		set_mouse_filter_of_children(child, filter)
