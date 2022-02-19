tool
class_name SmoothTabContainer
extends Container

enum Direction {
	HORIZONTAL, 
	VERTICAL
}

const TAB_CONTAINER_NAME = "SmoothTabs_TabsContainer"
const TAB_GROUP_NAME = "SmoothTabs_Tab"
const TAB_NAME_PREFIX = "SmoothTabs_Tab_"

export (int) var current_tab = 0 setget set_current_tab, get_current_tab
export (Array, String) var tab_labels = []
export (StyleBox) var tab_foreground
export (StyleBox) var tab_background
export (StyleBox) var panel setget set_panel, get_panel
export (Font) var tab_font
export (Color) var tab_foreground_font_color
export (Color) var tab_background_font_color
export (float) var tab_separation setget set_tab_separation, get_tab_separation
export (float) var side_margin setget set_side_margin, get_side_margin

export (Direction) var direction setget set_direction, get_direction
export (bool) var update = false setget set_update, get_update

var tabs_container = get_node_or_null(TAB_CONTAINER_NAME)


func add_child(node:Node, legible_unique_name=false) -> void:
	.add_child(node, legible_unique_name)
	
	if node is PanelContainer:
		node.add_stylebox_override("panel", panel)
	
	sort_children()

func remove_child(node:Node) -> void:
	if is_instance_valid(node):
		.remove_child(node)
	sort_children()


func sort_children() -> void:
	if not tabs_container and not is_instance_valid(tabs_container):
		create_tabs_container()
	
	move_child(tabs_container, 0)
	clear_tabs()
	
	var index:int = 0
	for label in tab_labels:
		create_tab(index, label)
		index += 1
	
	fit_tabs_container()
	rearrange_tabs()
	fit_tabs()
	fit_panels()
	(tabs_container as Container).queue_sort()


func fit_panels() -> void:
	if tabs_container and is_instance_valid(tabs_container):
		# find the rect for children to fit into
		var child_rect:Rect2 = get_rect()
		match direction:
			HORIZONTAL:
				child_rect.size.y -= tabs_container.rect_size.y
				child_rect.position.y += tabs_container.rect_size.y
				
			VERTICAL:
				child_rect.size.x -= tabs_container.rect_size.x
				child_rect.position.x += tabs_container.rect_size.x
		
		# adjust positions and sizes of all children with new tab size
		for child in get_children():
			if child.name != TAB_CONTAINER_NAME and child is Control:
				fit_child_in_rect(child, child_rect)


func fit_tabs_container() -> void:
	var first_child:Control = tabs_container.get_child(0)
	match direction:
		HORIZONTAL:
			tabs_container.rect_size.x = rect_size.x
			if first_child:
				tabs_container.rect_size.y = first_child.rect_size.y
		VERTICAL:
			tabs_container.rect_size.y = rect_size.y
			if first_child:
				tabs_container.rect_size.x = first_child.rect_size.x
	


func fit_tabs() -> void:
	if tabs_container and is_instance_valid(tabs_container):
		var tab_size:Vector2 = Vector2.ZERO
		var tab_position:Vector2 = Vector2.ZERO
		
		var start_size:Vector2 = rect_size
		if len(tab_labels) > 0:
			match direction:
				HORIZONTAL:
					start_size.x -= (2 * side_margin)
					tab_size.x = start_size.x / float(len(tab_labels))
					tab_position.x = tab_size.x + tab_separation
				VERTICAL:
					start_size.y -= (2 * side_margin)
					tab_size.y = start_size.y / float(len(tab_labels))
					tab_position.y = tab_size.y + tab_separation
			
			var index:int = 0
			for label in tab_labels:
				var tab:Label = tabs_container.get_node_or_null(TAB_NAME_PREFIX + label)
				if tab:
					tab.rect_size = tab_size
					tab.rect_position = tab_position * index
					match direction:
						HORIZONTAL:
							tab.rect_position.x += side_margin
						VERTICAL:
							tab.rect_position.y += side_margin
				
				index += 1


func rearrange_tabs() -> void:
	if tabs_container and is_instance_valid(tabs_container):
		var index:int = 0
		for text in tab_labels:
			var tab:Label = tabs_container.get_node_or_null(TAB_NAME_PREFIX + text)
			if tab:
				if index == current_tab:
					tab.raise()
			
			index += 1


func create_tabs_container() -> void:
	tabs_container = Container.new()
	
	tabs_container.name = TAB_CONTAINER_NAME

	add_child(tabs_container)
	tabs_container.owner = self


func create_tab(index:int, text:String):
	if tabs_container and is_instance_valid(tabs_container):
		# create node
		var tab = Label.new()
		tab.add_to_group(TAB_GROUP_NAME)
		
		tab.text = text
		tab.name = (TAB_NAME_PREFIX + str(text))
		tab.align = Label.ALIGN_CENTER
		tab.valign = Label.VALIGN_CENTER
		
		# set tab style
		set_tab_style(index, tab)
		
		tabs_container.add_child(tab)
		tab.owner = self


func clear_tabs() -> void:
	for tab in tabs_container.get_children():
		if tab.is_in_group(TAB_GROUP_NAME):
			tab.name += "_Clear"
			tab.queue_free()
	

func set_tab_style(index:int, tab:Label) -> void:
	if tab is Label:
		tab.add_font_override("font", tab_font)
		if index == current_tab:
			tab.add_stylebox_override("normal", tab_foreground)
			tab.add_color_override("font_color", tab_foreground_font_color)
		else:
			tab.add_stylebox_override("normal", tab_background)
			tab.add_color_override("font_color", tab_background_font_color)


func set_current_tab(tab:int) -> void:
	current_tab = tab
	sort_children()


func get_current_tab() -> int:
	return current_tab


func set_panel(panel_style_box:StyleBox) -> void:
	panel = panel_style_box
	# Adjust all child panels to have the same panel background
	for child in get_children():
		if child is PanelContainer:
			child.add_stylebox_override("panel", panel_style_box)


func get_panel() -> StyleBox:
	return panel


func set_update(_update:bool) -> void:
	update = false
	sort_children()


func get_update() -> bool:
	return false


func set_direction(new_direction:int) -> void:
	direction = new_direction
	sort_children()


func get_direction() -> int:
	return direction


func set_tab_separation(new_separation:float) -> void:
	tab_separation = new_separation
	sort_children()


func get_tab_separation() -> float:
	return tab_separation


func set_side_margin(new_margin:float) -> void:
	side_margin = new_margin
	sort_children()


func get_side_margin() -> float:
	return side_margin
