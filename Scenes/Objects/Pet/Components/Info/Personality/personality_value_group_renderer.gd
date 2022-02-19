tool
class_name PersonalityValueGroupRenderer
extends VBoxContainer

export (StyleBox) var empty_style_box = StyleBoxFlat.new() setget set_empty_style_box, get_empty_style_box
export (StyleBox) var filled_style_box = StyleBoxFlat.new() setget set_filled_style_box, get_filled_style_box
export (Color) var empty_font_color = Color("#afd7e0e7")
export (Color) var filled_font_color = Color("#c8b4defa")

export (int, 0, 5) var value = 0 setget set_value, get_value


func set_empty_style_box(new_style_box:StyleBox) -> void:
	empty_style_box = new_style_box
	for node in get_children():
		if node is PersonalityValueRenderer:
			node.empty_style_box = empty_style_box


func get_empty_style_box() -> StyleBox:
	return empty_style_box


func set_filled_style_box(new_style_box:StyleBox) -> void:
	filled_style_box = new_style_box
	for node in get_children():
		if node is PersonalityValueRenderer:
			node.filled_style_box = filled_style_box


func get_filled_style_box() -> StyleBox:
	return filled_style_box


func set_value(new_value:int) -> void:
	value = new_value

	for node in get_children():
		if node is PersonalityValueRenderer:
			node.value = new_value
	update_font_color()


func update_font_color() -> void:
	var label:Label = find_node("Label")
	if value > 0 and label:
		label.add_color_override("font_color", filled_font_color)
	elif label:
		label.add_color_override("font_color", empty_font_color)


func get_value() -> int:
	return value
