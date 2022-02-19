tool
extends HBoxContainer

onready var children:Array = get_children()
#var currently_sorting:Array = []

func _ready() -> void:
	for child in children:
		if child is ButtonExpansionMenu:
			child.connect("toggle_started", self, "start_sort", [child])
			child.yield_before_animation = true
	yield(get_tree(), "idle_frame")
	editor_sort()


func _notification(what:int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		editor_sort()


func editor_sort() -> void:
	var offset:float = 0.0
	for child in get_children():
		child.rect_position.x = offset
		
		if child is ButtonExpansionMenu:
			if child.is_open:
				offset += child.find_node("MenuContainer").rect_size.x + get_constant("separation")
			else:
				offset += child.find_node("OpenButton").rect_size.x + get_constant("separation")
		else:
			offset += child.rect_size.x + get_constant("separation")

func start_sort(_is_open:bool, node:ButtonExpansionMenu) -> void:
	
	for child in children:
		if child != node and child is ButtonExpansionMenu and child.is_open:
			child.disconnect("toggle_started", self, "start_sort")
			child.yield_before_animation = false
			child.toggle()
			child.yield_before_animation = true
			yield(Timers.wait(0.25), "completed")
			child.connect("toggle_started", self, "start_sort", [child])
	
	sort()

func sort() -> void:
	if len(children) > 0 and children[0] is Control:
		var offset:float = children[0].rect_position.x
		
		var index:int = 0
		for child in children:
			tween_child(child, offset)
			
			if child is ButtonExpansionMenu:
				if child.is_open:
					offset += child.nodes.menu.rect_size.x + get_constant("separation") * (index + 1)
				else:
					offset += child.nodes.open_button.rect_size.x + get_constant("separation") * (index + 1)
			else:
				offset += child.rect_size.x + get_constant("separation") * (index + 1)
				
		index += 1

func tween_child(child, offset) -> void:
	
	Tweens.tween(
			child,
			"rect_position",
			child.rect_position,
			Vector2(offset, child.rect_position.y),
			0.5
	)
	
	yield(Timers.wait(0.25), "completed")
	if child is ButtonExpansionMenu:
		while (
				child.current_toggle_state is GDScriptFunctionState 
				and child.current_toggle_state.is_valid()
		):
			child.current_toggle_state = child.current_toggle_state.resume()
		
