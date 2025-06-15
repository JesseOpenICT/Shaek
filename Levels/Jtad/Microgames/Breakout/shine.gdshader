shader_type canvas_item;

uniform sampler2D noise : repeat_enable ;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float density : hint_range(0.0, 1.0);
uniform vec3 color : source_color;

vec2 circleUV(vec2 uv) {
    vec2 muv = vec2((uv.x-.5),(uv.y-.5)); //Coords adjusted for the new center.
    float theta = (atan(muv.x,muv.y) / (2.*PI));
    return vec2(theta, -length(muv)*2.);
}

void fragment() {
	vec2 circle = circleUV(UV);
	COLOR.a = texture(noise, vec2(circle.x+TIME*.2) ).r + texture(noise, vec2(circle.x+.5-TIME*.1) ).r;
	COLOR.a *= circle.y+1.3;
	COLOR.a = max(0, COLOR.a);
	COLOR = texture(screen_texture, UV)-density*.1 + vec4(COLOR.a * color, 1.)*density;
}
