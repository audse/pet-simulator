extends Control

signal toggled(is_open)
var _connect

onready var nodes:Dictionary = {
	animation_player = $AnimationPlayer,
	build_here_menu = find_node("BuildHereMenu"),
	build_objects_menu = find_node("BuildObjectsMenu"),
	demolish_menu = find_node("DemolishMenu"),
	done_button = find_node("DoneButton"),
	finished_button = find_node("FinishedButton"),
}

var is_open:bool = false


func _ready() -> void:
	nodes.animation_player.play("RESET")
	nodes.done_button.connect("pressed", self, "toggle")
	nodes.finished_button.connect("pressed", self, "finish_button_pressed")
	
	_connect = States.Build.connect("enter_state", self, "enter_state")
	_connect = States.Build.connect("exit_state", self, "exit_state")
	_connect = States.Build.Type.connect("enter_state", self, "enter_type_state")
	_connect = States.Build.Type.connect("exit_state", self, "exit_type_state")


func enter_state(next_state:int) -> void:
	match next_state:
		States.Build.EDITING:
			nodes.finished_button.queue_enter()
			
			$VBoxContainer/MarginContainer2/HBoxContainer.visible = false
			$VBoxContainer/MarginContainer2/EditingMenu.visible = true
			$VBoxContainer/MarginContainer2/EditingMenu.queue_sort()


func exit_state(next_state:int) -> void:
	match next_state:
		States.Build.EDITING:
			nodes.finished_button.queue_exit()
			$VBoxContainer/MarginContainer2/HBoxContainer.visible = true
			$VBoxContainer/MarginContainer2/EditingMenu.visible = false


func enter_type_state(next_state:int) -> void:
	match next_state:
		States.Build.DOOR:
			nodes.finished_button.queue_exit()


func exit_type_state(next_state:int) -> void:
	match next_state:
		States.Build.DOOR:
			nodes.finished_button.queue_enter()


func toggle() -> void:
	if not is_open:
		is_open = true
		nodes.animation_player.queue("Open")
		
		States.Build.set_to(States.Build.READY)
		
	else:
		yield(Timers.wait(0.25), "completed")
		is_open = false
		nodes.animation_player.play("Open", -1, -1.75, true)
		
		States.Build.set_to(States.Build.ZERO)
		
		
	emit_signal("toggled", is_open)


func finish_button_pressed() -> void:
	States.Build.set_to(States.Build.READY)
