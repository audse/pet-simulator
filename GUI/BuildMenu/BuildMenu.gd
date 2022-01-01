extends VBoxContainer

signal construct_button_pressed
signal show_menu
signal hide_menu

onready var Buttons:Dictionary = {
	"Construct": $Margin/Grid/Construct,
	"Design": $Margin/Grid/Design,
	"Furnish": $Margin/Grid/Furnish
}

func _on_pressed() -> void:
	if $Margin/Grid.visible:
		hide()
	else:
		show()

func hide() -> void:
	var offset:Vector2 = $HBoxContainer/Button.rect_position
	Tweens.pop_out(Buttons.Construct, 0, 0.65, offset - Buttons.Construct.rect_position)
	Tweens.pop_out(Buttons.Design, 0.1, 0.65, offset - Buttons.Design.rect_position)
	yield(Tweens.pop_out(Buttons.Furnish, 0.2, 0.65, offset - Buttons.Furnish.rect_position), "completed")
	$Margin/Grid.visible = false
	emit_signal("hide_menu")

func show() -> void:
	$Margin/Grid.visible = true
	var offset:Vector2 = $HBoxContainer/Button.rect_position
	Tweens.pop_in(Buttons.Construct, 0, 0.65, offset - Buttons.Construct.rect_position)
	Tweens.pop_in(Buttons.Design, 0.1, 0.65, offset - Buttons.Design.rect_position)
	Tweens.pop_in(Buttons.Furnish, 0.2, 0.65, offset - Buttons.Furnish.rect_position)
	emit_signal("show_menu")

func _on_Construct_Button_pressed():
	emit_signal("construct_button_pressed")
