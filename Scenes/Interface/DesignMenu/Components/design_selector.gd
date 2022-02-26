class_name DesignSelector
extends ScrollColumnContainer

export (String, "exterior", "floor", "interior", "roof") var type:String
export (Array, String, 
		"brick", "paint", "siding", "stone", "stucco", "wood", # exterior
		"carpet", "wood", "tile", # floor
		"paint", "panel", "wallpaper", # interior
		"shingle", "plank" # roof
) var categories:Array = []
export (StyleBoxFlat) var border_stylebox:StyleBoxFlat = StyleBoxFlat.new()

var border_radius_shader:Shader = preload("res://Assets/Shaders/border_radius.gdshader")
var pop_button_script:Script = preload("res://Nodes/Control/PopButton/pop_button.gd")
var texture_manager:DesignTextureManager = DesignTextureManager.new()
var design_button_group:PopButtonGroup = PopButtonGroup.new()

var designs:Array = []
var is_open:bool = false

func _ready() -> void:
	nodes.animation_player.play("RESET")
	for category in categories:
		designs.append_array(
			texture_manager.get_icon_texture_array(type, category)
		)
	
	border_stylebox = border_stylebox.duplicate()
	border_stylebox.set_corner_radius_all(
			(nodes.column_container.get_child_size().x / 3)
	)
	
	for tile in designs:
		# create button with tile texture
		var button:Button = create_button()
		var texture_rect:TextureRect = create_texture_rect(tile.texture)
		
		nodes.column_container.add_child(button)
		button.add_child(texture_rect)
		
		texture_rect.show_behind_parent = true
		
		# adjust background/border
		button.add_stylebox_override("normal", border_stylebox)
		button.add_stylebox_override("hover", border_stylebox)
		button.add_stylebox_override("focus", StyleBoxEmpty.new())
		button.add_stylebox_override("pressed", border_stylebox)
		button.self_modulate.a = 0.4
		
		# add metadata to transfer on click
		button.set_meta("tile", tile.tile)
		button.set_meta("option", tile.option)
		
		_connect = button.connect("pressed", self, "button_pressed", [button])
	
	design_button_group.hide_on_start = true
	design_button_group.delay_increment = 0.05
	design_button_group.setup(nodes.column_container.get_children())
	
	modulate.a = 0


func enter() -> void:
	is_open = true
	nodes.animation_player.play("RESET")
	yield(get_tree(), "idle_frame")
	
	modulate.a = 1
	nodes.animation_player.play("Enter")
	yield(nodes.animation_player, "animation_finished")
	design_button_group.queue_enter()
	.enable()


func exit() -> void:
	is_open = false
	nodes.animation_player.play_backwards("Enter")
	yield(design_button_group.queue_exit(), "completed")
	modulate.a = 0
	.disable()


func button_pressed(button:Button) -> void:
	States.Design.emit_signal(
			"design_selected", 
			type,
			button.get_meta("tile")["id"], 
			button.get_meta("option")
	)


func create_button() -> Button:
	# add functionality
	var button:Button = Button.new()	
	button.set_script(pop_button_script)
	button.hide_on_start = true
	
	# add border radius
	button.material = ShaderMaterial.new()
	button.material.shader = border_radius_shader
	button.material.set_shader_param("radius", 0.5)
	
	button.mouse_filter = Button.MOUSE_FILTER_PASS
#	button.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
	
	return button


func create_stylebox() -> StyleBoxFlat:
	var stylebox:StyleBoxFlat = StyleBoxFlat.new()
	
	# adjust border
	stylebox.set_corner_radius_all(
		(nodes.column_container.get_child_size().x / 4) - 4
	)
	stylebox.set_border_width_all(1)
	
	# adjust background
	stylebox.set_expand_margin_all(3.0)
	
	return stylebox


func create_texture_rect(texture:Texture) -> TextureRect:
	var texture_rect:TextureRect = TextureRect.new()
	texture_rect.texture = texture
	
	# adjust sizing
	texture_rect.expand = true
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.anchor_right = 1.0
	texture_rect.anchor_bottom = 1.0
	
	# add border radius
	texture_rect.material = ShaderMaterial.new()
	texture_rect.material.shader = border_radius_shader
	texture_rect.material.set_shader_param("radius", 0.5)
	
	texture_rect.mouse_filter = TextureRect.MOUSE_FILTER_IGNORE
	return texture_rect
