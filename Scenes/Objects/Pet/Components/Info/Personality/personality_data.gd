class_name PersonalityData
extends Resource

""" Personality ranges from 0 to 5 """
var active:int = 0
var clean:int = 0
var playful:int = 0
var smart:int = 0
var social:int = 0


func _init(
	is_random:bool=true,
	active_value:int=active,
	clean_value:int=clean,
	playful_value:int=playful,
	smart_value:int=smart,
	social_value:int=social
) -> void:
	if is_random:
		generate_random()
	else:
		active = active_value
		clean = clean_value
		playful = playful_value
		smart = smart_value
		social = social_value


func generate_random() -> void:
	var points:int = 15
	
	# assign values in a random order (to not bias toward end)
	var indeces:Array = [0, 1, 2, 3, 4]
	indeces.shuffle()
	
	for index in indeces:
		
		var value:int = 0
		if points >= 5:
			value = Globals.random.randi_range(0, 5)
			
			# value of 0 should be kinda rare, reroll it once
			if value == 0:
				value = Globals.random.randi_range(0, 5)
			
			points -= value
		else:
			value = points
			points = 0
		
		# assign random value based on random index
		match index:
			0: active = value
			1: clean = value
			2: playful = value
			3: smart = value
			4: social = value
