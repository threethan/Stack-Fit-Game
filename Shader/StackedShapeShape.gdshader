shader_type spatial;
render_mode unshaded;
uniform vec4 color = vec4(0.5, 0.5, 0.5, 0.0);
uniform vec3 wobble = vec3(0,0,0);
uniform float squish = 0.0;
uniform float fade = 0.0;

const vec3 def_norm = vec3(0.0,1.0,0.0);
const vec3 static_offset = vec3(0.25, 0.25, 0.30)/2.0; //= def_norm.y * + (def_norm.z - def_norm.x/3.0) * vec3(0.10, 0.05, 0.05) + def_norm.x * vec3(-0.01, 0.03, -0.02);

uniform vec4 base_color = vec4(0.5,0.5,0.5,0);
uniform vec4 top_color  = vec4(0.5,0.5,0.5,0);

float saturation(vec3 c) {
	float avg = (c.r+c.g+c.b)/3.0;
	return abs(avg-c.r) + abs(avg-c.g) + abs(avg-c.b);
}

void vertex() {
	// CUSTOM
	if (VERTEX.y == 0.0) NORMAL.y -= 1.0; //Gradient
	// Wobble anim
	VERTEX.y += (wobble * VERTEX).x + (wobble * VERTEX).z;
	VERTEX.y -= squish;
	if (VERTEX.y < 0.0) {
		VERTEX.y = 0.0;
		NORMAL = def_norm;
	}


	// DEFAULT
	COLOR.rgb = NORMAL.y * vec3(0.25, 0.25, 0.30)/2.0 + (NORMAL.z - NORMAL.x/3.0) * vec3(0.10, 0.05, 0.05) + NORMAL.x * vec3(-0.01, 0.03, -0.02) - static_offset;
	COLOR.a = (COLOR.r+COLOR.g+COLOR.b)/3.0;
	COLOR.rgb = mix(vec3(COLOR.a), COLOR.rgb, saturation(COLOR.rgb));
}


void fragment() {
	vec3 surf = mix(base_color.rgb, top_color.rgb, pow(SCREEN_UV.y,2));
	ALBEDO = mix(color.rgb+static_offset, surf, fade) + COLOR.rgb;
}

