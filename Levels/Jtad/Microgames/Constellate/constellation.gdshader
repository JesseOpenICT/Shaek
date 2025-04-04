shader_type canvas_item;

uniform sampler2D constellation;
uniform float opacity;
uniform vec3 color : source_color;

void fragment() {
	COLOR.rgb += opacity * texture(constellation, UV).a * color;
}