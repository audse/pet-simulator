class_name NeedsRenderer
extends MarginContainer

export (Color) var low_color = Color("#ce2b46")
export (Color) var med_low_color = Color("#cd643b")
export (Color) var med_color = Color("#ccb441")
export (Color) var med_high_color = Color("#809c31")
export (Color) var high_color = Color("#2d884d")

var data:NeedsData setget set_data, get_data

var animate:bool = false

onready var bars:Dictionary = {
	activity = find_node("ActivityBar"),
	comfort = find_node("ComfortBar"),
	hunger = find_node("HungerBar"),
	hygiene = find_node("HygieneBar"),
	sleep = find_node("SleepBar")
}

func _ready() -> void:
	if animate:
		queue_update_bars()
	else:
		update_bars()


func set_data(new_data:NeedsData) -> void:
	data = new_data
	if animate:
		queue_update_bars()
	else:
		update_bars()
	

func get_data() -> NeedsData:
	return data


func get_color_from_value(value:float) -> Color:
	if value >= 0.8:
		return high_color
	elif value >= 0.6:
		return med_high_color
	elif value >= 0.4:
		return med_color
	elif value >= 0.2:
		return med_low_color
	else:
		return low_color


func update_bar(bar:ProgressBar, value:float) -> void:
	bar.self_modulate = get_color_from_value(value)
	bar.value = value


func queue_update_bar(bar:ProgressBar, value:float) -> void:
	bar.rect_pivot_offset = bar.rect_size / 2
	
	# tween value
	Tweens.tween(bar, "value", bar.value, value, 1)
	
	# animate first half
	Tweens.tween(bar, "rect_scale", bar.rect_scale, Vector2(1.05, 1.5), 0.5)
	Tweens.tween(
		bar, 
		"self_modulate", 
		bar.self_modulate, 
		get_color_from_value(value).linear_interpolate(Color("#ffffff"), 0.25),
		0.5
	)
	yield(Timers.wait(0.5), "completed")
	
	# animate second half
	Tweens.tween(bar, "rect_scale", bar.rect_scale, Vector2(1, 1), 0.5)
	Tweens.tween(
		bar, 
		"self_modulate", 
		bar.self_modulate, 
		get_color_from_value(value),
		0.5
	)
	yield(Timers.wait(0.5), "completed")


func update_bars(update_data:NeedsData=data) -> void:
	if is_inside_tree():
		if update_data:
			update_bar(bars.activity, update_data.activity)
			update_bar(bars.comfort, update_data.comfort)
			update_bar(bars.hunger, update_data.hunger)
			update_bar(bars.hygiene, update_data.hygiene)
			update_bar(bars.sleep, update_data.sleep)
		else:
			update_bar(bars.activity, 0.0)
			update_bar(bars.comfort, 0.0)
			update_bar(bars.hunger, 0.0)
			update_bar(bars.hygiene, 0.0)
			update_bar(bars.sleep, 0.0)


func queue_update_bars(update_data:NeedsData=data) -> void:
	if is_inside_tree():
		if update_data:
			queue_update_bar(bars.activity, update_data.activity)
			queue_update_bar(bars.comfort, update_data.comfort)
			queue_update_bar(bars.hunger, update_data.hunger)
			queue_update_bar(bars.hygiene, update_data.hygiene)
			queue_update_bar(bars.sleep, update_data.sleep)
		else:
			queue_update_bar(bars.activity, 0.0)
			queue_update_bar(bars.comfort, 0.0)
			queue_update_bar(bars.hunger, 0.0)
			queue_update_bar(bars.hygiene, 0.0)
			queue_update_bar(bars.sleep, 0.0)

func render_from_empty() -> void:
	update_bars(NeedsData.new())
	queue_update_bars()
