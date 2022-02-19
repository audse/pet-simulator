shader_type canvas_item;

uniform float blur_amount : hint_range(0, 5);

void fragment() {
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount).rgb;
	COLOR.a *= (texture(TEXTURE, UV).a * 2.0);
}
