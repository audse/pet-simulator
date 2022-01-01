extends TileMap

var hidden_color:Color = Color("#00ffffff")
var color:Color = Color("#32ffffff")
var active_color:Color = Color("#45ff848d")

func _ready() -> void:
	modulate = hidden_color

func start() -> void:
	Tweens.tween(self, "modulate", modulate, color, 0.25)

func activate() -> void:
	Tweens.tween(self, "modulate", modulate, active_color, 0.25)

func stop() -> void:
	Tweens.tween(self, "modulate", modulate, hidden_color, 0.25)
