extends Control

signal build_button_pressed
signal design_button_pressed
signal furnish_button_pressed
var _connect

onready var nodes:Dictionary = {
	menu_animation_player = find_node("AnimationPlayer")
}

onready var buttons:Dictionary = {
	main_menu = find_node("MainButton"),
	build = find_node("BuildButton"),
	design = find_node("DesignButton"),
	furnish = find_node("FurnishButton"),
}

var main_menu_open:bool = false

func _ready() -> void:
	# Set up main menu button
	_connect = buttons.main_menu.connect("pressed", self, "toggle")
	nodes.menu_animation_player.current_animation = "RESET"
	
	# Set up action buttons
	_connect = buttons.build.connect("pressed", self, "emit_signal", ["build_button_pressed"])
	_connect = buttons.design.connect("pressed", self, "emit_signal", ["design_button_pressed"])
	_connect = buttons.furnish.connect("pressed", self, "emit_signal", ["furnish_button_pressed"])
	
	# gets a little glitchy when resizing windows...
	_connect = get_tree().get_root().connect("size_changed", self, "_window_size_changed")


func toggle():
	if not main_menu_open:
		nodes.menu_animation_player.play("Open")
		main_menu_open = true
	else:
		nodes.menu_animation_player.play("Close", 0.5, 1.5)
		main_menu_open = false


func _window_size_changed() -> void:
	if main_menu_open:
		nodes.menu_animation_player.current_animation = "Open"
		nodes.menu_animation_player.advance(1.0)
	else:
		nodes.menu_animation_player.current_animation = "RESET"
