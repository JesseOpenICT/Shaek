shader_type canvas_item;

uniform sampler2D glow;
uniform sampler2D background : hint_screen_texture;

void fragment() {
	COLOR = texture(background, UV);
	COLOR += texture(glow, UV);
}
