extern number time;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
	vec4 resColor = Texel(texture, texture_coords);
	
	resColor.a = clamp(
		sin(texture_coords.x + time) * .25 +
		cos(texture_coords.y + time) * .25 +
		.5,
		0, 1
	);
	
	return resColor;
}
