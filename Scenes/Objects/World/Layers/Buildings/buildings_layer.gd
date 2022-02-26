class_name BuildingsLayer
extends Node2D

var _connect

onready var save:Save = $Save
onready var renderer:BuildingsLayerRenderer = $Renderer
onready var input_controller:BuildingsLayerInputController = $InputController


func _ready() -> void:
	renderer.draw_save_data(save.load_data())
	
	_connect = input_controller.connect("build_here", self, "build_here")
	
	_connect = States.Build.connect("exit_state", self, "save_data")


func build_here(coord:Vector2) -> void:
	renderer.place_building(coord)


func save_data(prev_state:int) -> void:
	yield(Timers.wait(1), "completed")
	if prev_state in [
		States.Build.PLACING, 
		States.Build.EDITING, 
		States.Build.DEMOLISHING, 
		States.Build.CONFIRM_DEMOLISH
	]: save.save_data(renderer.collect_save_data())
