shader_type canvas_item;

uniform float circle : hint_range(0.0, 1.0, 0.05);

void fragment() {
	float n = length(UV- vec2(.5));
	if (n/.63 <= circle) {
		discard;
	}
}
