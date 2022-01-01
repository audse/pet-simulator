extends Button

signal reached_end

export var start_delay:float = 0
export var position_delta:int = 3
export var duration:float = 1.5

onready var original_position:Vector2 = rect_position
onready var max_position:Vector2 = Vector2(original_position.x, original_position.y + position_delta)

var _connect

func _ready() -> void:
	_connect = connect("reached_end", self, "move")
	yield(Timers.wait(start_delay), "completed")
	move()

func move() -> void:
	var target_position = (
		max_position
		if rect_position.distance_to(original_position) < 2
		else original_position
	)
	$Tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		target_position,
		duration * 0.5,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	$Tween.start()
	yield($Tween, "tween_completed")
	emit_signal("reached_end")
