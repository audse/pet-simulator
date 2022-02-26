extends Node2D

signal wander_completed

var _connect

func _ready():
	($Sprite as DogSprite).play_next("default")

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed() and not event.is_echo():
		pass
#		yield(trot(get_global_mouse_position()), "completed")
#		$Sprite.play_next("default")

func trot(target_position:Vector2) -> void:
	var time:float = get_trot_time(target_position)
	
	# Adjust the sprite to face the direction of the target position
	var target_direction:int = (
		Globals.Direction.LEFT
		if global_position.x < target_position.x
		else Globals.Direction.RIGHT
	)
	
	yield(($Sprite as DogSprite).set_direction(target_direction), "completed")
	
	# Play the sprite animation and move to position
	($Sprite as DogSprite).play_next("trot")
	yield(($Sprite as DogSprite), "animation_started")
	yield(Tweens.move(self, target_position, time), "completed")

func get_trot_time(target_position:Vector2) -> float:
	# Calculate the time the trot animation will take
	var distance:float = global_position.distance_to(target_position)
	var time:float = (distance / 100) * 1.25
	return time
	
func wander() -> void:
	var start_position:Vector2 = global_position
	var position_delta:Vector2 = Vector2(
		Globals.random.randf_range(-100, 100),
		Globals.random.randf_range(-15, 15)
	)
	
	var target_position:Vector2 = Vector2(0, 0)
	target_position.x = start_position.x + position_delta.x
	target_position.y = start_position.y + position_delta.y
	
	yield(trot(target_position), "completed")
	
	var pause_time:float = 5.5 - get_trot_time(target_position)
	var pause_action:String = (
		"sit"
		if bool(Globals.random.randi_range(0, 1))
		else "default"
	)
	
	($Sprite as DogSprite).play_next(pause_action)
	yield(($Sprite as DogSprite), "animation_started")
	
	yield(Timers.wait(pause_time), "completed")
	emit_signal("wander_completed")
