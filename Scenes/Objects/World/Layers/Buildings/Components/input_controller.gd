class_name BuildingsLayerInputController
extends Node2D

signal build_here(coord)
var _connect

onready var nodes:Dictionary = {
	guide_grid = $GuideGrid,
	placement_guide = $PlacementGuide
}

func _ready() -> void:
	_connect = States.Build.connect("enter_state", self, "enter_state")
	_connect = States.Build.connect("exit_state", self, "exit_state")
	
	_connect = States.Build.connect("build_here_pressed", self, "build_here")


func enter_state(next_state:int) -> void:
	match next_state:
		States.Build.ZERO:
			nodes.guide_grid.exit()
			
		States.Build.READY:
			pass
			
		States.Build.PLACING:
			nodes.placement_guide.start(nodes.guide_grid)
			nodes.guide_grid.activate()
			
		States.Build.EDITING:
			pass
		
		States.Build.DEMOLISHING:
			nodes.guide_grid.activate()


func exit_state(prev_state:int) -> void:
	match prev_state:
		States.Build.ZERO:
			nodes.guide_grid.enter()
			
		States.Build.READY:
			pass
			
		States.Build.PLACING:
			nodes.placement_guide.stop()
			nodes.guide_grid.deactivate()
			
		States.Build.EDITING:
			pass
		
		States.Build.DEMOLISHING:
			nodes.guide_grid.deactivate()


func build_here() -> void:
	var coordinates:Vector2 = nodes.guide_grid.world_to_map(
			nodes.placement_guide.position
	)
	emit_signal("build_here", coordinates)
