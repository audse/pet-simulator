extends Control

var _connect

var data:FateData setget set_data, get_data

onready var renderers := {
	info = $InfoRenderer,
	label = $LabelRenderer
}

func _ready() -> void:
	_connect = renderers.label.connect("button_pressed", renderers.info, "queue_toggle")


func set_data(data_value:FateData) -> void:
	data = data_value


func get_data() -> FateData:
	return data
