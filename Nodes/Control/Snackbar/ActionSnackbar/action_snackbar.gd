class_name ActionSnackbar
extends Snackbar

onready var ActionButtons:PopButtonGroup = PopButtonGroup.new()

func _ready() -> void:
	ActionButtons.setup($Panel/Margin/HBox.get_children())
	yield(get_tree(), "idle_frame")
	if hide_on_start:
		ActionButtons.hide()


func enter() -> void:
	ActionButtons.enter()
	.enter()
