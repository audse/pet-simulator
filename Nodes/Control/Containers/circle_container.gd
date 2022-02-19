tool
class_name CircleContainer
extends Container

enum Edge {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM
}

export (float) var extra_margin = 0.0 setget set_extra_margin, get_extra_margin
export (bool) var fit_children_inside = false setget set_fit_children_inside, get_fit_children_inside

export (float) var degree_range = 360.0 setget set_degree_range, get_degree_range
export (float) var degree_offset = 0.0 setget set_degree_offset, get_degree_offset


var center:Vector2
var radius:float


func _notification(what:int) -> void:
	match what:
		NOTIFICATION_SORT_CHILDREN:
			sort_children()


func sort_children() -> void:
	
	radius = (rect_size.x / 2) - extra_margin if (rect_size.x < rect_size.y) else (rect_size.y / 2) - extra_margin
	center = rect_size / 2
	
	var children:Array = get_children()
	
	var degree_increment:float = degree_range / float(len(children) if len(children) > 0 else 1)
	
	var index:int = 0
	for child in children:
		
		if child is Control:
			
			# Find perfect position
			var degree:float = (degree_increment * index) + degree_offset
			
			child.rect_position = Vector2(
				center.x + radius * cos(degree * (PI / 180)),
				center.y + radius * sin(degree * (PI / 180))
			)
			
			# Offset to center
			child.rect_position -= child.rect_size / 2
			
			if fit_children_inside:
				# create a new radius, customized to the current node's size
				var temp_center:Vector2 = center - (child.rect_size / 2)
				var temp_radius:float = radius - (child.rect_size.x / 2)
				
				child.rect_position = Vector2(
					temp_center.x + temp_radius * cos(degree * (PI / 180)),
					temp_center.y + temp_radius * sin(degree * (PI / 180))
				)
			
		index += 1


func set_extra_margin(margin_value:float) -> void:
	extra_margin = margin_value
	sort_children()


func get_extra_margin() -> float:
	return extra_margin


func set_fit_children_inside(fit_value:bool) -> void:
	fit_children_inside = fit_value
	sort_children()


func get_fit_children_inside() -> bool:
	return fit_children_inside


func set_degree_range(degree_range_value:float) -> void:
	degree_range = degree_range_value
	sort_children()


func get_degree_range() -> float:
	return degree_range


func set_degree_offset(degree_value:int) -> void:
	degree_offset = degree_value
	sort_children()


func get_degree_offset() -> int:
	return degree_offset
