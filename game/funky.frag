extern number time;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
	vec4 resColor = Texel(texture, texture_coords);
	
	resColor.r = clamp((sin(resColor.r + time    ) * .5) + .5, 0, 1);
	resColor.g = clamp((sin(resColor.g + time * 2) * .5) + .5, 0, 1);
	resColor.b = clamp((sin(resColor.b + time * 4) * .5) + .5, 0, 1);
	
	return resColor;
}
