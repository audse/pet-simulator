class_name Fate
extends Control

var _connect

onready var nodes := {
	timer = $Timer,
	share_resource = $ShareResource,
	save = $Save,
}
onready var components := {
	render_controller = $RenderController
}

var data:FateData setget set_data, get_data

func _ready() -> void:
	var fate_data := FateData.new()
	
	var load_data:Dictionary = nodes.save.load_data()
	if load_data:
		fate_data.load_save_data(load_data)
	
	nodes.share_resource.resource = fate_data


func set_data(data_value:FateData) -> void:
	data = data_value
	_connect = data.connect("amount_changed", self, "save")


func get_data() -> FateData:
	return data


func save(_amount:int) -> void:
	var save_data := data.collect_save_data()
	nodes.save.save_data(save_data)


func _on_Timer_timeout() -> void:
	if data:
		data.amount += 1
