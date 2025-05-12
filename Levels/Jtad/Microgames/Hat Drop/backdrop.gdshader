shader_type canvas_item;


uniform sampler2D noise : repeat_enable;
uniform sampler2D gradient;
uniform sampler2D gradient2;
uniform float morph : hint_range(0.0, 1.0);


vec2 circleUV(vec2 uv) {
    vec2 muv = vec2((uv.x-.5),(uv.y-.5)); //Coords adjusted for the new center.
    float theta = (atan(muv.x,muv.y) / (2.*PI));
    return vec2(theta, -length(muv)*2.);
}

void fragment() {
	vec2 circle = circleUV(vec2((UV.x-.5)*.7+.5, UV.y/2.-.1));
	float shift = (TIME+morph*3.)*.04;
	float light = texture(noise, circle+vec2(shift, 2.*shift)).r;
	COLOR = texture(gradient, vec2(light)) * (1.-morph) + texture(gradient2, vec2(light)) * (morph);
}

