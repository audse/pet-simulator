class_name BuildingsLayer
extends Node2D

var _connect

var saver:Save = Save.new("building")

onready var renderer := $Renderer
onready var input_controller := $InputController


func _ready() -> void:
	renderer.draw_save_data(saver.load_data())
	
	_connect = input_controller.connect("build_here", self, "build_here")


func build_here(coord:Vector2) -> void:
	renderer.place_building(coord)
