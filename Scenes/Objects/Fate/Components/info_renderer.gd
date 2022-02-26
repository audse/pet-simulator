"""fate/components/info_renderer.gd"""
extends Control

var _connect

var data:FateData setget set_data, get_data

onready var modal:Modal = $Modal
onready var close_button:Button = find_node("CloseButton")
onready var fate_value_label:Label = find_node("FateValueLabel")

func _ready() -> void:
	_connect = close_button.connect("pressed", self, "queue_exit")


func queue_toggle() -> void:
	modal.queue_toggle()


func queue_enter() -> void:
	modal.queue_enter()


func queue_exit() -> void:
	modal.queue_exit()


func set_data(data_value:FateData) -> void:
	data = data_value
	if "amount" in data and NodeRef.is_node_valid(fate_value_label, Label):
		fate_value_label.text = str(data.amount)
		
		_connect = data.connect("amount_changed", self, "set_amount")


func get_data() -> FateData:
	return data


func set_amount(amount_value:int) -> void:
	fate_value_label.text = str(amount_value)
