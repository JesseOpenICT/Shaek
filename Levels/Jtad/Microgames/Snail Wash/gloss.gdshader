shader_type canvas_item;

uniform float amount;
uniform sampler2D noise : repeat_enable;

void fragment() {
	float opacity = max(0.0, texture(noise, vec2(UV.x + UV.y)-TIME/3.).r -.3);
	COLOR.rgb += COLOR.rgb * opacity *.7 * amount;
}
