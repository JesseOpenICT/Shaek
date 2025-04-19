shader_type canvas_item;


uniform sampler2D shape;
uniform vec2 current_position;
const vec2 target_position = vec2(.5);
uniform float depth = 1.;

float add_silhouette_layer(float n, vec2 uv) {
	float scale = (1. - n*0.2*depth);
	vec2 end_uv = ((uv-0.5) / scale) + 0.5 + current_position*(scale-1.);

	float color = 1.-texture(shape, end_uv).r;
	return color;
}

vec3 silhouette_color(float n) {
	vec3 color = vec3(sin(n), sin(n+PI/3.*2.), sin(n-PI/3.*2.)) /2. + .5 ;
	return color;
}

void fragment() {
	COLOR.rgb = vec3(0.0);
	COLOR.rgb += add_silhouette_layer(0, UV) * silhouette_color(0.+TIME);
	COLOR.rgb += add_silhouette_layer(1, UV) * silhouette_color(1.+TIME);
	COLOR.rgb += add_silhouette_layer(2, UV) * silhouette_color(2.+TIME)*.5;
	COLOR.rgb += add_silhouette_layer(-1, UV) * silhouette_color(-1.+TIME)*.5;
	COLOR.rgb += vec3(0,0,0.09);
}
