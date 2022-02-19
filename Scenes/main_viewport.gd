extends Node2D


onready var parent:Viewport = get_parent()
onready var parent_viewport:Viewport = get_parent().get_viewport()


func _ready() -> void:
	parent.size = parent_viewport.size

func _process(_delta:float) -> void:
	pass
