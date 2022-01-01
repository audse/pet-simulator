extends Control

onready var Buttons:Dictionary = {
	"Build": $SafeZone/BuildMenu.Buttons,
}

func _show_tap_area() -> void:
	$TapArea.visible = true

func _hide_tap_area() -> void:
	$TapArea.visible = false

func _on_TapAreaButton_pressed():
	$SafeZone/BuildMenu.hide()
	_hide_tap_area()

func _on_BuildMenu_hide_menu():
	_hide_tap_area()

func _on_BuildMenu_show_menu():
	_show_tap_area()

func _on_BuildMenu_construct_button_pressed():
	$SafeZone/Construct.change_state(States.Construct.READY)
	$SafeZone/BuildMenu.hide()
