class_name PetActionsData
extends Resource

signal action_selected(action_id)

var actions:Array = [
	{
		id = "play",
		text = "Go play!",
	},
	{
		id = "sleep",
		text = "Go sleep!",
	},
	{
		id = "clean",
		text = "Go clean up!",
	},
	{
		id = "eat",
		text = "Go eat!"
	},
	{
		id = "explore",
		text = "Go explore!"
	}
]

func action_selected(action_id:String) -> void:
	emit_signal("action_selected", action_id)
	print(action_id)
