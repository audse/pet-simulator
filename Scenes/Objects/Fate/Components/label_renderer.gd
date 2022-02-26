""" fate/components/label_renderer.gd """
extends MarginContainer

signal button_pressed
var _connect

var data:FateData setget set_data, get_data

onready var button := $LabelButton


func _ready() -> void:
	_connect = button.connect("pressed", self, "_on_button_pressed")


func set_data(data_value:FateData) -> void:
	data = data_value
	(button as Button).text = str(data.amount)
	_connect = data.connect("amount_changed", self, "set_amount")


func get_data() -> FateData:
	return data


func set_amount(amount_value:int) -> void:
	(button as Button).text = str(amount_value)


func _on_button_pressed() -> void:
	emit_signal("button_pressed")
