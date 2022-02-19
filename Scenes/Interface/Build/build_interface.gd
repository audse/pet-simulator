extends Control

var _connect

onready var Snackbars = {
	New = $NewSnackbar,
	NewActions = $NewActionsSnackbar,
	Edit = $EditSnackbar,
	EditActions = $EditActionsSnackbar,
	Destroy = $DestroySnackbar,
}

onready var Modals = {
	Destroy = $DestroyModal
}

var current_menu:Node = null


func _ready() -> void:
	_connect = States.Build.connect("enter_state", self, "enter_state")


func enter_state(next_state:int) -> void:
	match next_state:
		States.Building.ZERO:
			toggle_menu(null)
		States.Building.READY:
			toggle_menu(Snackbars.New)
		States.Building.PLACING_OUTER_WALL:
			toggle_menu(Snackbars.NewActions)
		States.Building.EDITING:
			toggle_menu(Snackbars.Edit)
		States.Building.EDITING_OUTER_WALL:
			toggle_menu(Snackbars.EditActions)
		States.Building.DESTROYING:
			toggle_menu(Snackbars.Destroy)
		States.Building.CONFIRM_DESTROY:
			toggle_menu(Modals.Destroy)
		States.Building.DESTROYING_OUTER_WALL:
			toggle_menu(null)


func enter() -> void:
	States.Build.set_to(States.Building.READY)


func toggle_menu(menu:Node) -> void:
	# Wait for button interactions
	yield(Timers.wait(0.25), "completed")
	
	# Hide current menu
	if current_menu and current_menu.has_method("queue_exit"):
		current_menu.queue_exit()
		yield(Timers.wait(0.5), "completed")
	
	# Enter new menu
	current_menu = menu
	if current_menu and current_menu.has_method("queue_enter"):
		current_menu.queue_enter()


func _on_NewSnackbar_CloseButton_pressed():
	States.Build.set_to(States.Building.ZERO)


func _on_NewSnackbar_DoneButton_pressed():
	States.Build.set_to(States.Building.ZERO)


func _on_NewSnackbar_NewButton_pressed():
	Snackbars.NewActions.find_node("DoneButton").queue_swap_text("Build Here")
	States.Build.set_to(States.Building.PLACING_OUTER_WALL)


func _on_NewActionsSnackbar_DoneButton_pressed():
	States.Build.set_to(States.Building.EDITING_OUTER_WALL)
	Events.emit_signal("placement_finished")


func _on_NewActionsSnackbar_CancelButton_pressed():
	States.Build.set_to(States.Building.READY)


func _on_EditSnackbar_CloseButton_pressed():
	States.Build.set_to(States.Building.ZERO)


func _on_EditSnackbar_DoneButton_pressed():
	States.Build.set_to(States.Building.READY)


func _on_EditSnackbar_OuterWallButton_pressed():
	States.Build.set_to(States.Building.EDITING_OUTER_WALL)


func _on_EditActionsSnackbar_DoneButton_pressed():
	States.Build.set_to(States.Building.EDITING)


func _on_EditActionsSnackbar_CancelButton_pressed():
	States.Build.set_to(States.Building.EDITING)
	Events.emit_signal("edit_cancelled")


func _on_DestroyButton_pressed():
	States.Build.set_to(States.Building.DESTROYING)


func _on_DestroySnackbar_CancelButton_pressed():
	States.Build.set_to(States.Building.READY)


func _on_DestroyModal_DestroyButton_pressed():
	States.Build.set_to(States.Building.DESTROYING_OUTER_WALL)


func _on_DestroyModal_modal_exited():
	States.Build.set_to(States.Building.READY)


func _on_DestroyModal_CancelButton_pressed():
	States.Build.set_to(States.Building.READY)
