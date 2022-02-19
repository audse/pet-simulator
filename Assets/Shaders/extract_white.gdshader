shader_type canvas_item;

void fragment(){
//	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
//    COLOR.a = 1.0 - texture(TEXTURE, UV).a;
	vec4 current_color = texture(TEXTURE, UV);
	bool r_similar = 1.0 - current_color.r < 0.1;
	bool g_similar = 1.0 - current_color.g < 0.1;
	bool b_similar = 1.0 - current_color.b < 0.1;
	bool a_similar = 1.0 - current_color.a < 1.0;
	if (r_similar && g_similar && b_similar && a_similar) {
		
	
//	if (current_color == vec4(1.0, 1.0, 1.0, 1.0)) {
//		COLOR = current_color;
	} else {
		COLOR.a = 0.0;
	}
}
