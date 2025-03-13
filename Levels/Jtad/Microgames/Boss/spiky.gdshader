shader_type canvas_item;

uniform sampler2D spikynoise : repeat_enable;

void fragment() {
	COLOR.rgb += .8 * (texture(spikynoise, (SCREEN_UV)/vec2(192, 256)*500.+TIME/6.)).rgb * (1.-COLOR.r);
	COLOR.rgb += .5 * texture(spikynoise, (SCREEN_UV)/vec2(192, 256)*500.+TIME*vec2(-.1, .5)).rgb;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
