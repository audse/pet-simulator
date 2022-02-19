extends Control

var _connect

onready var nodes:Dictionary = {
	vbox_container = $VBoxContainer,
	animation_player = find_node("AnimationPlayer"),
	done_button = find_node("DoneButton"),
	done_selecting_button = find_node("DoneSelectingButton"),
	
	exterior_button = find_node("ExteriorButton"),
	floor_button = find_node("FloorButton"),
	interior_button = find_node("InteriorButton"),
	roof_button = find_node("RoofButton"),
	
	selectors = {
		exterior = find_node("ExteriorSelector"),
		floor = find_node("FloorSelector"),
		interior = find_node("InteriorSelector"),
		roof = find_node("RoofSelector"),
	}
}

var is_open:bool = false

func _ready() -> void:
	# reset appearance
	nodes.animation_player.play("RESET")
	set_container_visibility(false)
	
	# state changes
	_connect = States.Design.connect("enter_state", self, "enter_state")
	_connect = States.Design.connect("exit_state", self, "exit_state")
	_connect = nodes.done_button.connect("pressed", self, "toggle")
	_connect = nodes.done_selecting_button.connect(
		"pressed",
		States.Design,
		"set_to",
		[States.Design.READY]
	)
	
	# selector buttons
	_connect = nodes.exterior_button.connect(
		"pressed",
		self,
		"toggle_selector",
		[nodes.selectors.exterior]
	)
	_connect = nodes.floor_button.connect(
		"pressed",
		self,
		"toggle_selector",
		[nodes.selectors.floor]
	)
	_connect = nodes.interior_button.connect(
		"pressed",
		self,
		"toggle_selector",
		[nodes.selectors.interior]
	)
	_connect = nodes.roof_button.connect(
		"pressed",
		self,
		"toggle_selector",
		[nodes.selectors.roof]
	)
	
	# selectors
	_connect = nodes.selectors.floor.connect(
			"item_rect_changed", 
			nodes.vbox_container, 
			"queue_sort"
	)
	_connect = nodes.selectors.interior.connect(
			"item_rect_changed", 
			nodes.vbox_container, 
			"queue_sort"
	)
	_connect = nodes.selectors.roof.connect(
			"item_rect_changed", 
			nodes.vbox_container, 
			"queue_sort"
	)


func enter_state(next_state:int) -> void:
	yield(close_all_selectors(), "completed")
	match next_state:
		States.Design.ZERO:
			yield(Timers.wait(0.75), "completed")
			nodes.animation_player.queue("Close")
			yield(nodes.animation_player, "animation_finished")
			# reset container visibility
			set_container_visibility(false)
			is_open = false
			
		States.Design.READY:
			if not is_open:
				yield(set_container_visibility(true), "completed")
				nodes.animation_player.queue("Open")
				is_open = true
			else:
				nodes.animation_player.queue("OpenInstructionLabel")
				States.Design.Selector.set_to(States.Design.ROOF)
			
		States.Design.SELECTING:
			nodes.animation_player.queue("OpenSelectors")
			nodes.selectors.roof.enter()


func exit_state(prev_state:int) -> void:
	yield(close_all_selectors(), "completed")
	match prev_state:
		States.Design.ZERO:
			pass
			
		States.Design.READY:
			nodes.animation_player.queue("CloseInstructionLabel")
			
		States.Design.SELECTING:
			nodes.animation_player.queue("CloseSelectors")


func close_all_selectors() -> void:
	for selector in nodes.selectors.values():
		if selector.is_open:
			yield(selector.exit(), "completed")
	yield(get_tree(), "idle_frame")


func toggle() -> void:
	if not is_open:
		States.Design.set_to(States.Design.READY)
		
	else:
		States.Design.set_to(States.Design.ZERO)
		States.Design.Selector.set_to(States.Design.ROOF)


func toggle_selector(selector:Node) -> void:
	if not selector.is_open:
		match selector:
			nodes.selectors.floor:
				States.Design.Selector.set_to(States.Design.FLOOR)
			nodes.selectors.interior:
				States.Design.Selector.set_to(States.Design.INTERIOR)
			nodes.selectors.roof:
				States.Design.Selector.set_to(States.Design.ROOF)
		
		for node in nodes.selectors.values():
			if node != selector:
				if node.is_open:
					node.exit()
		
		yield(Timers.wait(0.5), "completed")
		selector.enter()


func set_container_visibility(is_visible:bool) -> void:
	yield(get_tree(), "idle_frame")
	
	if is_visible:
		nodes.vbox_container.visible = true
		nodes.animation_player.play("RESET")
		yield(get_tree(), "idle_frame")
		nodes.vbox_container.modulate.a = 1
		
	else:
		nodes.vbox_container.visible = false
		nodes.vbox_container.modulate.a = 0
		nodes.animation_player.play("RESET")
		
