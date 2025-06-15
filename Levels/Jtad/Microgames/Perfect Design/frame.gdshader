shader_type canvas_item;

uniform sampler2D fishshape: filter_nearest;
uniform sampler2D noise : repeat_enable;
uniform vec3 color : source_color;

void fragment() {
	float opacity = texture(fishshape, UV).a;
	COLOR = vec4(color, opacity);

	COLOR.a += texture(fishshape, UV+texture(noise, .01*TIME+SCREEN_UV).rg*.14-.07).a;
	COLOR.a += texture(fishshape, UV-texture(noise, -.01*TIME+SCREEN_UV).rg*.14+.07).a;

	COLOR.a += texture(fishshape, UV+vec2(.008)).a;
	COLOR.a += texture(fishshape, UV-vec2(.008)).a;

	COLOR.a = min (COLOR.a, 1.);

	COLOR.a -= opacity;
	COLOR.a = COLOR.a *.8;
}
