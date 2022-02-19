class_name DoneCancelSnackbar
extends ActionSnackbar

signal DoneButton_pressed
signal CancelButton_pressed

export (bool) var close_on_button_press:bool = true

onready var DoneButton:PopButton = $Panel/Margin/HBox/DoneButton
onready var CancelButton:PopButton = $Panel/Margin/HBox/CancelButton

func queue_swap_text(done_button_text:String, cancel_button_text:String="") -> void:
	DoneButton.queue_swap_text(done_button_text)
	CancelButton.queue_swap_text(cancel_button_text)


func queue_reset_text() -> void:
	queue_swap_text("Done", "Cancel")
	

func _on_DoneButton_pressed() -> void:
	emit_signal("DoneButton_pressed")
	if close_on_button_press:
		yield(Timers.wait(0.2), "completed")
		.queue_exit()


func _on_CancelButton_pressed() -> void:
	emit_signal("CancelButton_pressed")
	if close_on_button_press:
		yield(Timers.wait(0.2), "completed")
		.queue_exit()
