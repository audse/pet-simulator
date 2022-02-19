class_name Grid
extends TileMap

export var colors:Dictionary = {
	default = Color("#32ffffff"),
	hidden = Color("#00ffffff"),
	active = Color("#45d1d9de"),
}


func _ready() -> void:
	modulate = colors.hidden


func enter() -> void:
	Tweens.tween(self, "modulate", modulate, colors.default, 0.25)
	
	for x in range(-30, 30):
		for y in range(-30, 30):
			set_cell(x, y, 0)


func activate() -> void:
	Tweens.tween(self, "modulate", modulate, colors.active, 0.25)


func deactivate() -> void:
	Tweens.tween(self, "modulate", modulate, colors.default, 0.25)


func exit() -> void:
	Tweens.tween(self, "modulate", modulate, colors.hidden, 0.25)
