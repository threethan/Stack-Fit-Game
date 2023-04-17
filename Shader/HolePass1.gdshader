shader_type spatial;
render_mode unshaded;
uniform vec4 hole_color = vec4(0.5,0.5,0.5,0);
uniform vec4 base_color = vec4(0.5,0.5,0.5,0);
uniform vec4 top_color  = vec4(0.5,0.5,0.5,0);

uniform float alpha = 0.0;

float saturation(vec3 c) {
	float avg = (c.r+c.g+c.b)/3.0;
	return abs(avg-c.r) + abs(avg-c.g) + abs(avg-c.b);
}

const vec3 def_norm = vec3(0.0,1.0,0.0);
const vec3 static_offset = vec3(0.25, 0.25, 0.30); 
const float hole_darken = 0.11; //Gradient
const float hole_darken2= 0.07; //Additional darken of bottom

void vertex() {
	// CUSTOM
	VERTEX *= vec3(1,-1,1);
	// DEFAULT
	COLOR.rgb = NORMAL.y * vec3(0.17, 0.19, 0.25) + (NORMAL.z - NORMAL.x/3.0) * vec3(0.10, 0.05, 0.05) + NORMAL.x * vec3(-0.01, 0.03, -0.02) - static_offset;
	COLOR.a = (COLOR.r+COLOR.g+COLOR.b)/3.0;
	COLOR.rgb = mix(vec3(COLOR.a), COLOR.rgb, saturation(COLOR.rgb));
	// CUSTOM
	if (VERTEX.y < -0.05)
		COLOR.rgb -= hole_darken;
	if (NORMAL == def_norm)
		COLOR.rgb -= hole_darken2;
}

void fragment() {
	ALBEDO = mix(base_color.rgb, top_color.rgb, pow(SCREEN_UV.y,2)) + (COLOR.rgb + hole_color.rgb) * alpha;
	//ALPHA_SCISSOR = 0.1;
	if (alpha <= 0.0) {
		ALPHA = 0.0;
	}
}