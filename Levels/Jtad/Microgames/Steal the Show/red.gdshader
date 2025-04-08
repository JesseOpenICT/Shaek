shader_type spatial;
render_mode cull_disabled, unshaded;

uniform vec3 color = vec3(1,0,.1);

void fragment() {
	ALBEDO = color;
}
