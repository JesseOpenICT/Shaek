shader_type canvas_item;

uniform sampler2D image : repeat_enable;
uniform float scale;

void fragment() {
    vec2 screenUV = (SCREEN_UV / SCREEN_PIXEL_SIZE) * scale + vec2(cos(2.*TIME+.1),0);

    vec2 wave1 = screenUV + vec2(sin(screenUV).y*sin(TIME), cos(screenUV).x*cos(TIME));

    float PI23 = 2.*PI/3.;
    float quicktime = TIME*1. + 0.3*(wave1.x - .5*wave1.y);
    vec3 quirk = (vec3(sin(quicktime),sin(quicktime-PI23),sin(quicktime+PI23))+1.)*.5;

    COLOR = vec4(vec3(0.), 1.);
    COLOR.rgb += texture(image, wave1).rgb * quirk;

    COLOR.rgb += texture(image, wave1+ 3.*sin(TIME*.5)).rgb *  0.5*quirk*( -sin(TIME*1.) +1.);
    }