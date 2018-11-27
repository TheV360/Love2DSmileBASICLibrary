extern number time;

const float PI = 3.141592;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
	vec2 txCoords = texture_coords;
	
	//float sine_size = sin(time * PI * 2) * 16 + 24;
	
	txCoords.x = mod(texture_coords.x + (cos((texture_coords.y + time) * 2 * PI) * .25), 1);
	txCoords.y = mod(texture_coords.y + (sin((texture_coords.x + time) * 2 * PI) * .25), 1);
	
	vec4 resColor = Texel(texture, txCoords);
	
	/*
	resColor.a = clamp(
		sin(((texture_coords.x * sine_size) + time) * PI * 2) * .25 +
		cos(((texture_coords.x * sine_size) + time) * PI * 2) * .25 +
		.5,
		0, 1
	);
	*/
	
	return resColor;
}
