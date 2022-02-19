extends AnimatedAutotile


onready var base_map:AnimatedAutotile


func draw(animate:bool=true) -> void:
	var is_hidden:bool = modulate.a == 0
	var is_empty:bool = len(get_used_cells()) == 0
	
	if base_map and (is_hidden or is_empty):
		modulate.a = 0
		clear()
		
		for cell in base_map.get_used_cells():
			set_cellv(cell, 0)
		update_bitmask_region()
		
		if animate:
			fade_in()
		else:
			modulate.a = 1


func hide() -> void:
	fade_out()


func fade_in() -> void:
	Tweens.tween(self, "modulate:a", modulate.a, 1, 0.5)


func fade_out() -> void:
	Tweens.tween(self, "modulate:a", modulate.a, 0, 0.5)
