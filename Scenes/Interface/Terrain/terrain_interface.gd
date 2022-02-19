extends "res://GUI/Components/Snackbar/Snackbar.gd"

onready var Nodes = {
	Panel = $Panel,
	VBox = $Panel/VBoxContainer,
	PathOption = $Panel/VBoxContainer/ScrollGrid,
	PathOptionGrid = $Panel/VBoxContainer/ScrollGrid/GridControl/Grid
}

onready var Buttons = {
	PathOptions = PopButtonGroup.new()
}

func _ready():
	yield(Nodes.PathOption.setup(), "completed")
	_adjust_height_from_grid()
	

func queue_enter() -> void:
	.queue_enter()
	yield(Timers.wait(0.25), "completed")
	Buttons.PathOptions.queue_enter()


func _adjust_height_from_grid() -> void:
	var min_size = Vector2(0, 0)
	for node in Nodes.VBox.get_children():
		if node is Control:
			min_size.y += node.rect_size.y
			min_size.y += Nodes.VBox.get_constant("separation")
	Nodes.Panel.rect_min_size = min_size
