class_name Structure
extends Node2D

var _connect

onready var DustParticles:PackedScene = preload("res://Assets/Particles/tscn/DustCircleParticles.tscn")

onready var design_texture_manager:DesignTextureManager = DesignTextureManager.new()
onready var nodes:Dictionary = {
	structure_map = $StructureMap,
	arrow_handles = $ArrowHandles,
	handles = $Handles,
	edit_button = {
		parent = $EditButtonParent,
		button = $EditButtonParent/EditButton,
		animation_player = $EditButtonParent/EditButton/AnimationPlayer
	},
	demolish_button = {
		parent = $DestroyButtonParent,
		button = $DestroyButtonParent/DestroyButton,
		animation_player = $DestroyButtonParent/DestroyButton/AnimationPlayer
	},
	particles = $Particles,
	placement_guide = $PlacementGuide,
}

onready var marker_buttons:Array = [
	nodes.edit_button,
	nodes.demolish_button
]

var undraggable_tiles:Array = [
	Vector2(2, 1), Vector2(9, 2), Vector2(5, 1), 
	Vector2(5, 2), Vector2(6, 1), Vector2(6, 2), 
	Vector2(8, 2), Vector2(10, 3), Vector2(11, 1), 
	Vector2(9, 0), Vector2(9, 1), Vector2(10, 2)
]

var base_map:AnimatedAutotile

func _ready() -> void:
	
	_connect = States.Build.connect("enter_state", self, "enter_build_state")
	_connect = States.Build.connect("exit_state", self, "exit_build_state")
	
	_connect = States.Build.Type.connect("enter_state", self, "enter_build_type_state")
	_connect = States.Build.Type.connect("exit_state", self, "exit_build_type_state")
	_connect = States.Build.connect("build_door_pressed", self, "place_door")
	_connect = States.Build.connect("build_window_pressed", self, "place_window")
	
	_connect = States.Design.connect("enter_state", self, "enter_design_state")
	_connect = States.Design.connect("exit_state", self, "exit_design_state")
	
	_connect = nodes.handles.connect("handle_drag_released", self, "_on_handle_drag_released")
	_connect = nodes.arrow_handles.connect("handle_drag_released", self, "_on_handle_drag_released")
	
	base_map = nodes.structure_map.base_map
	nodes.arrow_handles.base_map = base_map
	nodes.handles.base_map = base_map


func enter_build_state(next_state:int) -> void:
	match next_state:
		States.Build.ZERO:
			States.Build.target_node = null
			
		States.Build.READY:
			States.Build.target_node = null
			
			toggle_marker_button(nodes.edit_button)
			
		States.Build.PLACING:
			pass
			
		States.Build.EDITING:
			if States.Build.target_node == self:
				yield(Timers.wait(0.5), "completed")
				start_editing()
		
		States.Build.DEMOLISHING:
			toggle_marker_button(nodes.demolish_button)
		
		States.Build.CONFIRM_DEMOLISH:
			if States.Build.target_node == self:
				yield(destroy(), "completed")
				
				# If state has not already been changed by the user,
				# change it to continue demolishing
				if States.Build.state == States.Build.CONFIRM_DEMOLISH:
					States.Build.set_to(States.Build.DEMOLISHING)


func exit_build_state(prev_state:int) -> void:
	match prev_state:
		States.Build.ZERO:
			pass
			
		States.Build.READY:
			toggle_marker_button(null)
			
		States.Build.PLACING:
			pass
		
		States.Build.EDITING:
			if States.Build.target_node == self:
				stop_editing()
		
		States.Build.DEMOLISHING:
			toggle_marker_button(null)


func enter_build_type_state(next_state:int) -> void:
	if States.Build.target_node == self:
		match next_state:
			States.Build.WALL:
				pass
			States.Build.DOOR, States.Build.WINDOW:
				stop_editing()
				toggle_placement_guide(true)


func exit_build_type_state(prev_state:int) -> void:
	if States.Build.target_node == self:
		match prev_state:
			States.Build.WALL:
				pass
			States.Build.DOOR, States.Build.WINDOW:
				start_editing()
				toggle_placement_guide(false)


func enter_design_state(next_state:int) -> void:
	match next_state:
		States.Design.READY:
			toggle_marker_button(nodes.edit_button)


func exit_design_state(prev_state:int) -> void:
	match prev_state:
		States.Design.READY:
			toggle_marker_button(null)


func place_at(start_x:int, start_y:int) -> void:
	# Create 3x3 structure originating at start point
	for y in [start_y - 1, start_y, start_y + 1]:
		for x in [start_x - 1, start_x, start_x + 1]:
			
			nodes.structure_map.set_cell(x, y)
	
	nodes.structure_map.fade_enter()
	draw_dust_particles(nodes.structure_map.get_used_cells())


func start_editing() -> void:
	stop_editing()
	# Draw all handles
	nodes.handles.draw_from_base_map(undraggable_tiles)
	nodes.arrow_handles.draw()


func stop_editing() -> void:
	# Delete all handles
	nodes.handles.delete_all()
	nodes.arrow_handles.delete_all()


func destroy() -> void:
	# We don't want the edit button to appear as it's getting destroyed
	# which happens during transition to States.Build.READY
	nodes.edit_button.parent.queue_free()
	
	# Short delay from clicking destroy in modal
	yield(Timers.wait(1), "completed")
	
	# Draw dust for the entire building
	draw_dust_particles(nodes.structure_map.get_used_cells())
	
	# Fade out building as dust animation plays
	nodes.structure_map.fade_exit()
	
	# Wait for all animations finished
	yield(Timers.wait(1.5), "completed")
	queue_free()


func draw_dust_particles(cells:Array, amount:int=12) -> void:
	var dust_particles:Array = []
	# Draw dust in each cell
	for cell in cells:
		
		# Create instance of dust particles scene
		var new_dust:Particles2D = DustParticles.instance()
		
		# Position on top of cell
		var dust_position:Vector2 = base_map.map_to_world(cell)
		var dust_map_offset:Vector2 = Vector2(
				base_map.cell_size.x / 2,
				base_map.cell_size.y / 2
		)
		new_dust.position = dust_position + dust_map_offset
		nodes.particles.add_child(new_dust)
		
		# Start emitting
		new_dust.amount = amount
		new_dust.emitting = true
		
		dust_particles.append(new_dust)

	# Wait for all dust to be finished animating
	yield(Timers.wait(1.5), "completed")
	for node in dust_particles:
		# Delete all dust
		node.queue_free()


func toggle_marker_button(marker_button) -> void:
	for button in marker_buttons:
		if is_instance_valid(button.parent) and button.parent.visible:
			exit_marker_button(button)
	if marker_button:
		yield(Timers.wait(0.4), "completed")
		if is_instance_valid(marker_button.parent):
			enter_marker_button(marker_button)


func enter_marker_button(marker_button:Dictionary) -> void:
	marker_button.button.modulate.a = 0
	yield(get_tree(), "idle_frame")
	marker_button.parent.visible = true
	var bounding_box:Dictionary = base_map.get_bounding_box()
	
	var new_position:Vector2 = Vector2(
			bounding_box.left,
			bounding_box.up
	)
	var new_size:Vector2 = Vector2(
			bounding_box.right - bounding_box.left + 24,
			bounding_box.down - bounding_box.up + 24
	)
	
	marker_button.parent.position = new_position
	marker_button.button.rect_size = new_size
	
	var animation_offset:float = Globals.random.randf_range(0, 0.5)
	marker_button.animation_player.play("Float")
	marker_button.animation_player.advance(animation_offset)
	
	var delay:float = Globals.random.randf_range(0, 0.25)
	marker_button.button.queue_enter(delay)


func exit_marker_button(marker_button:Dictionary) -> void:
	var delay:float = Globals.random.randf_range(0, 0.25)
	marker_button.button.queue_exit(delay)


func toggle_placement_guide(to_show:bool) -> void:
	if to_show:
		var exterior_cells:Array = nodes.structure_map.get_exterior_cells()
		if len(exterior_cells):
			nodes.structure_map.highlight_cells(exterior_cells)
			nodes.placement_guide.start(
					base_map, 
					base_map.map_to_world(exterior_cells[0]) + Vector2(12, 12)
			)
	else:
		nodes.placement_guide.stop()
		nodes.structure_map.highlight_cells([])


func place_door() -> void:
	if States.Build.target_node == self:
		nodes.structure_map.add_door(
				base_map.world_to_map(
						nodes.placement_guide.position
				)
		)


func place_window() -> void:
	if States.Build.target_node == self:
		nodes.structure_map.add_window(
				base_map.world_to_map(
						nodes.placement_guide.position
				),
				true
		)


func _on_handle_drag_released(from_pos:Vector2, to_pos:Vector2, handle:Node) -> void:
	
	var from_coord:Vector2 = base_map.world_to_map(to_global(from_pos))
	var to_coord:Vector2 = base_map.world_to_map(to_global(to_pos))
	
	# Delete non-arrow handles
	nodes.handles.delete_all(false)
	
	if handle in nodes.handles.get_children():
		
		var cells_to_set:Array = base_map.get_cells_between_coords(
			from_coord,
			to_coord
		)
		
		# Draw dust from cells
		var dust_cells:Array = []
		for cell in cells_to_set:
			dust_cells.append(cell.to)
		draw_dust_particles(dust_cells, 12)
		
		# From the cells to set, find which ones are already used
		var cells_already_used:Array = []
		for cell in cells_to_set:
			if base_map.get_cellv(cell.to) != -1:
				cells_already_used.append(cell)
		
		# If all the cells to set are already used, 
		# the user probably wants to delete, not add
		if len(cells_to_set) == len(cells_already_used):
			
			# Adjust the `to` coord so that all tiles land
			# on the currently handled cell
			for cell in cells_to_set:
				cell.to = to_coord
			
			# We don't want to delete if no cells have been passed
			if to_coord != from_coord:
				yield(nodes.structure_map.slide_erase_cells(cells_to_set), "completed")
		
		else:
			# Adjust the `from` coord so that all tiles spawn
			# at the original point, rather than near the final point
			for cell in cells_to_set:
				cell.from = from_coord
			
			yield(nodes.structure_map.slide_set_cells(cells_to_set), "completed")
		
	elif handle in nodes.arrow_handles.get_children():
		
#		var direction:int = nodes.arrow_handles.get_direction_from_handle(handle)
#		var num_additions:int = nodes.arrow_handles.get_num_cells_passed_from_handle_direction(to_coord, direction)
		
		var direction:int = handle.direction
		var num_additions:int = handle.get_num_cells_passed(from_coord, to_coord)
		
		# Draw dust particles
		var dust_cells:Array = []
		for cell in base_map.add_to_direction(direction, num_additions):
			dust_cells.append(cell.to)
		draw_dust_particles(dust_cells, 12)
		
		yield(nodes.structure_map.slide_add_to_direction(direction, num_additions), "completed")
	
	nodes.handles.draw_from_tilemap(base_map, undraggable_tiles)
	nodes.arrow_handles.adjust_positions()


func _on_EditButton_pressed():
	match States.Mode.state:
		States.Mode.BUILD:
			States.Build.target_node = self
			States.Build.set_to(States.Build.EDITING)
		States.Mode.DESIGN:
			States.Design.target_node = self
			States.Design.set_to(States.Design.SELECTING)


func _on_DestroyButton_pressed():
	States.Build.target_node = self
	yield(Timers.wait(0.5), "completed")
	States.Build.set_to(States.Build.CONFIRM_DEMOLISH)


func draw_save_data(save_data:Dictionary) -> void:
	if save_data.has("cells"):
		for cell in save_data["cells"]:
			nodes.structure_map.set_cellv(cell)
		
	if save_data.has("design"):
		var design_keys:Array = ["exterior", "floor", "interior", "roof"]
		if save_data["design"].has_all(design_keys):
			nodes.structure_map.set_designs(save_data["design"])


func collect_save_data() -> Dictionary:
	return {
		"name": "New Building",
		"cells": base_map.get_used_cells(),
		"design": nodes.structure_map.design
	}
