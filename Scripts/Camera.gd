extends Camera2D

var min_zoom = 0.5
var max_zoom = 2
var zoom_sensitivity = 10
var zoom_speed = 0.05

var events = {}
var last_drag_distance = 0
var dragging_disabled:bool = false

func _process(_delta:float) -> void:
	# fix jitter
	position = position.round()
	force_update_scroll()
	
func _unhandled_input(event):
	if event is InputEventScreenTouch and not dragging_disabled:
		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)

	if event is InputEventScreenDrag and not dragging_disabled:
		events[event.index] = event
		if events.size() == 1:
			position -= event.relative.rotated(rotation) * zoom.x
		elif events.size() == 2:
			var drag_distance = events[0].position.distance_to(events[1].position)
			if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
				var new_zoom = (1 + zoom_speed) if drag_distance < last_drag_distance else (1 - zoom_speed)
				new_zoom = clamp(zoom.x * new_zoom, min_zoom, max_zoom)
				zoom = Vector2.ONE * new_zoom
				last_drag_distance = drag_distance
