shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform vec3 color : source_color;

void fragment() {
	float add_noise = texture(noise, vec2(UV.x-(UV.y/7.), TIME*.1)).r ;
	add_noise = max(0.0, add_noise*(1.- (UV.y/1.3)));
	COLOR.rgb += add_noise * color;
}
