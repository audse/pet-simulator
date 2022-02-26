extends Control

onready var nodes:Dictionary = {
	main_menu = $MainMenu,
	build_menu = $BuildMenu,
}


func _on_MainMenu_build_button_pressed() -> void:
	States.Mode.set_to(States.Mode.BUILD)
	nodes.main_menu.toggle()
	
	yield(Timers.wait(0.5), "completed")
	nodes.build_menu.toggle()


func _on_MainMenu_design_button_pressed() -> void:
	States.Mode.set_to(States.Mode.DESIGN)
	nodes.main_menu.toggle()
	
	yield(Timers.wait(0.5), "completed")
	nodes.design_menu.toggle()


func _on_MainMenu_furnish_button_pressed() -> void:
	States.Mode.set_to(States.Mode.FURNISH)
	nodes.main_menu.toggle()


func _on_BuildMenu_toggled(is_open:bool) -> void:
	if not is_open:
		States.Mode.set_to(States.Mode.PLAY)
