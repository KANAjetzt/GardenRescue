shader_type canvas_item;

uniform float u_border_width : hint_range(0.0, 1.0, 0.01);
uniform vec4 u_color_border : hint_color;

float border(vec2 uv, float border_width)
{
	vec2 bottom_left = step(vec2(border_width), uv);
	vec2 top_right = step(vec2(border_width), 1.0 - uv);
	return bottom_left.x * bottom_left.y * top_right.x * top_right.y;
}

void fragment(){
	float border = border(UV, u_border_width);
	
	vec4 color_base = vec4(0.0);
	vec4 color = mix(u_color_border, color_base, border);

	COLOR = color;
}