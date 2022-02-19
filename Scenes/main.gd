class_name Main
extends Node


onready var Nodes = {
	Build = $Build,
}

func _ready():
	randomize()
	Globals.random.randomize()
