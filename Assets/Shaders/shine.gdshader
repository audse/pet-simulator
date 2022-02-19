shader_type canvas_item;

uniform float speed = 0.25; // chagne to lower value like 0.1 to watch the movement
uniform float size = 0.25; // the flash beam size
uniform float strength = 0.25; // the color strength, you can change to -1 to test
uniform float slope = 0.5; // the flash slope
	
void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	float position = 1.0 - fract(TIME * speed) * 2.0; // this makes the value from -1 to 1, you can also change to 1 to -1 in reverse
	position = position + SCREEN_UV.y * slope; // calculate the position with y otherwise your beam is vertical
	float x_left = position - size * 0.5; //beam left position by size
	float x_right = position + size * 0.5; //right position by size
	
	if (SCREEN_UV.x >= x_left && SCREEN_UV.x <= x_right) {
		color.rgb += vec3(strength); //do your trick to make flash color
	} else {
		color.rgb = color.rgb; //keep the original color, you can also delete this line
	}
	
	COLOR = color;
}