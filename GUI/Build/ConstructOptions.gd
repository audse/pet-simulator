extends MarginContainer

func show() -> void:
	$VBox.visible = true
	Tweens.pop_in($VBox/Panel)
	
func hide() -> void:
	Tweens.pop_out($VBox/MarginContainer/AddWall, 0.1)
	yield(Tweens.pop_out($VBox/Panel), "completed")
	$VBox.visible = false

func reset_toggle() -> void:
	$VBox/Panel/HBoxContainer/Toggle.pressed = false
	$VBox/Panel/HBoxContainer/Toggle.manually_toggle(false)

func _on_Toggle_toggled(button_pressed:bool) -> void:
	if button_pressed: # Wall Mode
		Events.emit_signal("construct_toggle_mode", States.ConstructMode.WALL)
		
		# Show Add Wall button
		$VBox/MarginContainer/AddWall.modulate.a = 0
		Tweens.pop_in($VBox/MarginContainer/AddWall)
		
	else: # Shape Mode
		Events.emit_signal("construct_toggle_mode", States.ConstructMode.SHAPE)
		
		# Hide Add Wall button
		yield(Tweens.pop_out($VBox/MarginContainer/AddWall), "completed")

func _on_AddWall_pressed():
	Events.emit_signal("construct_add_wall_pressed")
