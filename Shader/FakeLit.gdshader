shader_type spatial;
render_mode unshaded;
uniform vec4 color = vec4(0.5, 0.5, 0.5, 0.0);

float saturation(vec3 c) {
	float avg = (c.r+c.g+c.b)/3.0;
	return abs(avg-c.r) + abs(avg-c.g) + abs(avg-c.b);
}

void vertex() {
	// DEFAULT
	COLOR.rgb = NORMAL.y * vec3(0.25, 0.25, 0.30) + (NORMAL.z - NORMAL.x/3.0) * vec3(0.10, 0.05, 0.05) + NORMAL.x * vec3(-0.01, 0.03, -0.02);
	COLOR.a = (COLOR.r+COLOR.g+COLOR.b)/3.0;
	COLOR.rgb = mix(vec3(COLOR.a), COLOR.rgb, saturation(COLOR.rgb));
}

void fragment() {
	ALBEDO = color.rgb + COLOR.rgb;
}