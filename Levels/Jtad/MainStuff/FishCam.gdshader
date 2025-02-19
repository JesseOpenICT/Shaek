shader_type canvas_item;

uniform sampler2D fishcam;

void fragment() {
	COLOR.rgb = texture(fishcam, SCREEN_UV).rgb;
}
