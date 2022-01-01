extends AnimatedSprite

signal animation_started

func play_next(next_anim:String, reverse=false) -> void:
	var prev_anim:String = animation
	var current_frame:int = frame
	
	if next_anim in ["sit"] and prev_anim in ["default", "trot"]:
		play("transition_stand_to_sit")
		yield(self, "animation_finished")
		
	if next_anim in ["default", "trot", "flip_h"] and prev_anim in ["sit"]:
		play("transition_stand_to_sit", true)
		yield(self, "animation_finished")
		print("standing...")
	
	if next_anim in ["default"] and prev_anim in ["trot"]:
		match current_frame:
			3, 4, 7, 8:
				play("transition_trot_to_default")
				frame = 2
			5, 6:
				play("transition_trot_to_default_frame-6")
			0:
				pass
			_:
				play("transition_trot_to_default")
		
		yield(self, "animation_finished")
	
	yield(Timers.wait(), "completed")
	play(next_anim, reverse)
	emit_signal("animation_started")

func set_direction(target_direction:int) -> void:
	var current_direction:int = (
		Globals.Direction.LEFT
		if flip_h
		else Globals.Direction.RIGHT
	)
	if target_direction != current_direction:
		yield(play_next("flip_h"), "completed")
		flip_h = !flip_h
	
	yield(Timers.wait(), "completed")
	
		
