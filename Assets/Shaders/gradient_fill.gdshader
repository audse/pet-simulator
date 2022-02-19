shader_type canvas_item;

uniform sampler2D gradient;

void fragment() {
	vec4 col = texture(gradient, UV.yx);
	COLOR = texture(TEXTURE,UV) * COLOR * col;
}