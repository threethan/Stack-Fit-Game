shader_type spatial;
render_mode unshaded, skip_vertex_transform;
uniform float inner = 1.0;
uniform float outer = 1.05;
uniform float amount = 0.1;

uniform vec3 wobble = vec3(0,0,0);
uniform float squish = 0.0;
uniform float fade = 1.0;

uniform vec4 base_color = vec4(10);
uniform vec4 top_color  = vec4(10);

void vertex() {
	//VERTEX = (WORLD_MATRIX * vec4(VERTEX, 0)).xyz;
	VERTEX = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// Wobble anim/squish (MUST BE SAME AS OTHER)
	VERTEX.y += (wobble * VERTEX).x + (wobble * VERTEX).z;
	VERTEX.y -= squish;
	if (VERTEX.y < 0.0) {
		VERTEX.y = 0.0;
	}
	// World space
	if (VERTEX.y > 0.0)
		VERTEX.xz += (VERTEX.y) * vec2(0.05, -0.5);
	VERTEX.y = -0.05;
	
	VERTEX = (INV_CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

const float thresh = 90.05;
void fragment() {
	ALPHA = 1.0;
	//ALPHA_SCISSOR = 0.1;

	vec3 expected_bg = mix(base_color.rgb, top_color.rgb, pow(SCREEN_UV.y,2));
	ALBEDO = expected_bg - 0.04*fade;
//	vec3 diff = texture(view_tex, SCREEN_UV).rgb - expected_bg;
//	if (abs(diff.r)<thresh && abs(diff.g)<thresh && abs(diff.b)<thresh) {
//		ALPHA = 1.0;
//		ALBEDO = expected_bg - 0.04*fade;
//	}
	//ALBEDO = texture(view_tex, SCREEN_UV).rgb;
}