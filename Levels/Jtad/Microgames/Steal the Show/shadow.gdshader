shader_type canvas_item;

uniform vec2 offset = vec2(0,0.01);

void fragment() {
	float base = COLOR.a;
	COLOR.a += texture(TEXTURE, UV-offset).a;
	COLOR.rgb = COLOR.rgb - (1.-base);
	
	//COLOR.a = diagonal;
	//COLOR.r = diagonal;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
