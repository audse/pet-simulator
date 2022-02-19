extends TabContainer

var _connect

onready var timer:Timer = $Timer
onready var tween:Tween = $Tween

var font_color_fg:Color = get_color("font_color_fg")
var font_color_bg:Color = get_color("font_color_bg")
var tab_fg:StyleBoxFlat = get_stylebox("tab_fg").duplicate()
var tab_bg:StyleBoxFlat = get_stylebox("tab_bg").duplicate()

#func _ready() -> void:
#	_connect = connect("tab_selected", self, "pop_tab")
#
#
#func _process(_delta:float) -> void:
#	if timer and not is_zero_approx(timer.time_left) and get_stylebox("tab_fg").border_width_top > 0:
#		var new_tab_fg:StyleBoxFlat = get_stylebox("tab_fg").duplicate()
#		print(new_tab_fg.border_width_top)
#		new_tab_fg.border_width_top -= 0.1
#
#		add_color_override("font_color_fg", get_color("font_color_fg").linear_interpolate(font_color_fg, 0.1))
#		add_stylebox_override("tab_fg", new_tab_fg)
#
#
#func pop_tab(_tab_index:int) -> void:	
#	var new_tab_fg:StyleBoxFlat = tab_fg.duplicate()
#	new_tab_fg.border_width_top = tab_bg.border_width_top
#	add_stylebox_override("tab_fg", new_tab_fg)
#	add_color_override("font_color_fg", font_color_bg)
#	timer.start()
#
