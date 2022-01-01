extends Node

var drag_delta:Vector2
var is_dragging:bool = false

func _ready():
	randomize()
	Globals.random.randomize()
	
	$CanvasLayer/Interface.Buttons.Build.Construct.connect("pressed", self, "_BuildMode_Construct_Button_pressed")
