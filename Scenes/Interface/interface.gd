extends Control

enum MenuStates {
	OPEN,
	CLOSED
}

var main_menu_state:int = MenuStates.CLOSED

enum ButtonGroups {
	MAIN_MENU
}

onready var Buttons:Dictionary = {
	ButtonGroups.MAIN_MENU: {
		Build = {
			"Button": $MainMenu/Buttons/VBox/BuildMargin/Build,
			"Icon": $MainMenu/Buttons/VBox/BuildMargin/Build/Icon,
		},
		Terrain = {
			"Button": $MainMenu/Buttons/VBox/Button2Margin/Terrain,
		},
		Button3 = {
			"Button": $MainMenu/Buttons/VBox/Button3Margin/Button3,
		},
		Button4 = {
			"Button": $MainMenu/Buttons/VBox/Button4Margin/Button4,
		}
	}
}

func _ready() -> void:
	# Set all main menu buttons to invisible (until main menu opened)
	_hide_buttons_in_group(ButtonGroups.MAIN_MENU)
	
	# Reset the main menu back to the first frame
	$MainMenu/Sprite.frame = 0

#
# INTERACTIVITY METHODS
#

func _on_MainMenu_pressed() -> void:
	if main_menu_state == MenuStates.CLOSED:
		_open_main_menu()
		
	elif main_menu_state == MenuStates.OPEN:
		_close_main_menu()

func _open_main_menu() -> void:
	$MainMenu/Sprite.play("default")
	main_menu_state = MenuStates.OPEN
	
	yield(Timers.wait(0.25), "completed")
	_pop_in_buttons_in_group(ButtonGroups.MAIN_MENU)

func _close_main_menu() -> void:
	_pop_out_buttons_in_group(ButtonGroups.MAIN_MENU)
	yield(Timers.wait(0.25), "completed")
	
	$MainMenu/Sprite.play("default", true)
	main_menu_state = MenuStates.CLOSED

#
# BUTTON SHOW/HIDE METHODS
#

func _pop_in_buttons_in_group(group:int, has_delay:bool=true) -> void:
	var delay:float = 0
	for node_name in Buttons[group]:
		_pop_in_button(group, node_name, delay)
		if has_delay:
			delay += 0.1

func _pop_out_buttons_in_group(group:int, has_delay:bool=true) -> void:
	var delay:float = 0
	for node_name in Buttons[group]:
		_pop_out_button(group, node_name, delay)
		if has_delay:
			delay += 0.1

func _hide_buttons_in_group(group:int) -> void:
	for node_name in Buttons[group]:
		_hide_button(group, node_name)

func _pop_in_button(group:int, node_name:String, delay:float) -> void:
	var current:Dictionary = Buttons[group][node_name]
	if "Button" in current:
		current.Button.visible = true
		yield(Tweens.pop_in_control_node(current.Button, delay), "completed")
	yield(Timers.wait(), "completed")
	
func _pop_out_button(group:int, node_name:String, delay:float) -> void:
	var current:Dictionary = Buttons[group][node_name]
	if "Button" in current:
		yield(Tweens.pop_out_control_node(current.Button, delay), "completed")
		current.visible = false
	yield(Timers.wait(), "completed")

func _hide_button(group:int, node_name:String) -> void:
	var current:Dictionary = Buttons[group][node_name]
	if current and "Button" in current:
		current.Button.modulate.a = 0
		current.Button.visible = false


func _on_Build_pressed():
	_close_main_menu()
	yield(Timers.wait(0.25), "completed")
	$BuildInterface.enter()
#	$BuildBottomPanel.animate_in()


func _on_Terrain_pressed():
	_close_main_menu()
	yield(Timers.wait(0.25), "completed")
#	$TerrainInterface.animate_in()
	pass # Replace with function body.
