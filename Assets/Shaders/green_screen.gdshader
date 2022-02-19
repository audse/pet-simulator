shader_type canvas_item;

uniform vec3 environment = vec3(0.3, 0.3, 0.3);

void fragment() {
	vec3 current_color = texture(TEXTURE, UV).rgb;
	vec3 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	if (distance(screen_color, environment) < 0.5) {
		COLOR.rgb = vec3(0.0, 0.0, 0.0);
	}
	COLOR.rgb = current_color;
}
