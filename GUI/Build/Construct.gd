extends Control

onready var Buttons:Dictionary = {
	"Group": $ButtonGroup,
	"Ready": {
		"Group": $ButtonGroup/ReadyButtonGroup,
		"Add": $ButtonGroup/ReadyButtonGroup/Add,
		"Finished": $ButtonGroup/ReadyButtonGroup/Finished,
	},
	"Adding": {
		"Group": $ButtonGroup/AddingButtonGroup,
		"Cancel": $ButtonGroup/AddingButtonGroup/Cancel,
		"BuildHere": $ButtonGroup/AddingButtonGroup/BuildHere,
	},
	"Building": {
		"Group": $ButtonGroup/BuildingButtonGroup,
		"Cancel": $ButtonGroup/BuildingButtonGroup/Cancel,
		"Finished": $ButtonGroup/BuildingButtonGroup/Finished,
	}
}

var state:int = States.Construct.UNSET
var _connect

func _ready() -> void:
	_connect = Events.connect("construct_editing", self, "change_state", [States.Construct.EDITING])

func show_buttons_in_group(group:Dictionary) -> void:
	if group.Group:
		group.Group.visible = true
	var delay:float = 0
	for button in group:
		if group[button] is Button:
			group[button].disabled = false
			Tweens.pop_in(group[button], delay)
			delay += 0.1
	var wait_time:float = 0.55 + delay
	yield(Timers.wait(wait_time), "completed")

func hide_buttons_in_group(group:Dictionary) -> void:
	var delay:float = 0
	for button in group:
		if group[button] is Button:
			group[button].disabled = true
			Tweens.pop_out(group[button], delay)
			delay += 0.1
	
	var wait_time:float = 0.55 + delay
	yield(Timers.wait(wait_time), "completed")
	if group.Group:
		group.Group.visible = false

func change_state(next_state:int) -> void:
	var prev_state:int = state
	
	if prev_state == States.Construct.READY:
		yield(hide_buttons_in_group(Buttons.Ready), "completed")
	elif prev_state == States.Construct.ADDING:
		yield(hide_buttons_in_group(Buttons.Adding), "completed")
	elif prev_state in [States.Construct.BUILDING, States.Construct.EDITING]:
		yield(hide_buttons_in_group(Buttons.Building), "completed")
		$Options.hide()
		$Options.reset_toggle()
	
	if next_state == States.Construct.READY:
		show_buttons_in_group(Buttons.Ready)
	elif next_state == States.Construct.ADDING:
		show_buttons_in_group(Buttons.Adding)
	elif next_state in [States.Construct.BUILDING, States.Construct.EDITING]:
		show_buttons_in_group(Buttons.Building)
		$Options.show()
	
	state = next_state
	Events.emit_signal("construct_state_changed", prev_state, next_state)

func _on_Ready_Add_Button_pressed() -> void:
	change_state(States.Construct.ADDING)

func _on_Ready_Finished_Button_pressed() -> void:
	change_state(States.Construct.UNSET)

func _on_Adding_BuildHere_Button_pressed() -> void:
	change_state(States.Construct.BUILDING)
	
func _on_Adding_Cancel_Button_pressed() -> void:
	change_state(States.Construct.READY)

func _on_Building_Cancel_Button_pressed() -> void:
	yield(self.change_state(States.Construct.CANCEL), "completed")
	change_state(States.Construct.READY)
	
func _on_Building_Finished_Button_pressed() -> void:
	change_state(States.Construct.READY)
