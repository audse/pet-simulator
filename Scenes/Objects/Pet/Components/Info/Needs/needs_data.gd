class_name NeedsData
extends Resource

signal need_changed(need)

var activity:float = 0.0
var comfort:float = 0.0
var hunger:float = 0.0
var hygiene:float = 0.0
var sleep:float = 0.0


func _init(
	activity_value:float=activity,
	comfort_value:float=comfort,
	hunger_value:float=hunger,
	hygiene_value:float=hygiene,
	sleep_value:float=sleep
) -> void:
	activity = activity_value
	comfort = comfort_value
	hunger = hunger_value
	hygiene = hygiene_value
	sleep = sleep_value


func generate_random() -> void:
	activity = Globals.random.randf_range(0.4, 0.8)
	comfort = Globals.random.randf_range(0.4, 0.8)
	hunger = Globals.random.randf_range(0.4, 0.8)
	hygiene = Globals.random.randf_range(0.4, 0.8)
	sleep = Globals.random.randf_range(0.4, 0.8)
	
