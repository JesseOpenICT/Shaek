shader_type canvas_item;

uniform float offset;

void fragment() {
	COLOR = texture(TEXTURE, UV+vec2(sin(SCREEN_UV.y * 20. +TIME + offset)*.05, 0));
	if (offset != 0.){
		COLOR.a *= .56;}
}
