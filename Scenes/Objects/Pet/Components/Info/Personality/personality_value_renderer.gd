tool
class_name PersonalityValueRenderer
extends Panel

export (int, 1, 5) var level:int = 1 setget set_level, get_level
export (int, 1, 5) var value:int = 1 setget set_value, get_value
export (StyleBox) var empty_style_box = StyleBoxFlat.new() setget set_empty_style_box, get_empty_style_box
export (StyleBox) var filled_style_box = StyleBoxFlat.new() setget set_filled_style_box, get_filled_style_box


func set_level(new_level:int) -> void:
	level = new_level
	update_style_box()


func get_level() -> int:
	return level


func set_value(new_value:int) -> void:
	value = new_value
	update_style_box()


func get_value() -> int:
	return value


func set_empty_style_box(new_style_box:StyleBox) -> void:
	empty_style_box = new_style_box
	update_style_box()
	

func get_empty_style_box() -> StyleBox:
	return empty_style_box


func set_filled_style_box(new_style_box:StyleBox) -> void:
	filled_style_box = new_style_box
	update_style_box()


func get_filled_style_box() -> StyleBox:
	return filled_style_box


func update_style_box() -> void:
	if value < level:
		add_stylebox_override("panel", empty_style_box)
	else:
		add_stylebox_override("panel", filled_style_box)
