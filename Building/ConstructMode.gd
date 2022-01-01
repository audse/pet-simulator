extends Node2D

var ConstructRoomScene:PackedScene = preload("res://Building/ConstructRoom.tscn")
var _connect

func _ready() -> void:
	_connect = Events.connect("construct_state_changed", self, "change_state")

func add_construct(coordinates) -> void:
	var new_construct:ConstructRoom = ConstructRoomScene.instance()
	$Constructs.add_child(new_construct, true)
	new_construct.start(
		int(coordinates.x), 
		int(coordinates.y)
	)
	adjust_construct_z_indeces()

func adjust_construct_z_indeces() -> void:	
	var constructs:Array = $Constructs.get_children()
	constructs.sort_custom(self, "sort_by_tile_y")
	var index:int = len(constructs)
	for construct in constructs:
		construct.z_index = index
		index -= 1

static func sort_by_tilemap_y(a:Node, b:Node) -> bool:
	var a_map = a.get_node_or_null("TileMap")
	var b_map = b.get_node_or_null("TileMap")
	if a_map and b_map:
		var a_lowest = a_map.get_furthest_cell_value(Globals.Direction.DOWN)
		var b_lowest = b_map.get_furthest_cell_value(Globals.Direction.DOWN)
		
		# If equal, use the most recent node
		if a_lowest == b_lowest:
			return a.get_position_in_parent() > b.get_position_in_parent()
		else:
			return a_lowest > b_lowest
	else:
		return false

func change_state(prev_state:int, next_state:int) -> void:
	
	if prev_state == States.Construct.READY:
		# Hide edit buttons for already-made constructs
		for construct in $Constructs.get_children():
			if construct is ConstructRoom:
				construct.hide_edit_button()
		
	elif prev_state == States.Construct.ADDING:
		# Hide grid highlight
		$GridHighlight.stop()
		
	elif prev_state in [States.Construct.BUILDING, States.Construct.EDITING]:
		# Stop building in prev construct
		var constructs:Array = $Constructs.get_children()
		for construct in constructs:
			construct.stop_all()
			construct.draw_roof()
	
	if next_state == States.Construct.READY:
		# Return grid to base color
		$Grid.start()
		# Show edit buttons for already-made constructs
		for construct in $Constructs.get_children():
			if construct is ConstructRoom:
				construct.show_edit_button()
		
	elif next_state == States.Construct.ADDING:
		# Show grid highlight
		$GridHighlight.start($Grid)
		# Change grid to active color
		$Grid.activate()
		
	elif next_state == States.Construct.BUILDING:
		# Add new construct
		var coordinates:Vector2 = $Grid.world_to_map($GridHighlight.position)
		add_construct(coordinates)
		
	elif next_state == States.Construct.CANCEL:
#		var constructs:Array = $Constructs.get_children()
#		var last_construct:ConstructRoom = constructs[len(constructs) - 1]
#		last_construct.queue_free()
		for construct in $Constructs.get_children():
			construct.stop_all()
		
	elif next_state == States.Construct.UNSET:
		$Grid.stop()
