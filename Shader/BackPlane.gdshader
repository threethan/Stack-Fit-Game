shader_type spatial;
render_mode unshaded;
uniform vec4 base_color = vec4(0.5,0.5,0.5,0);
uniform vec4 top_color  = vec4(0.5,0.5,0.5,0);

void fragment() {
	// Shitty dither pattern
//	vec2 pix = SCREEN_UV * 645644.856;
//	float n = mod(pix.x+pix.y*5.3, 1.0) - 0.5;
	ALBEDO = mix(base_color.rgb, top_color.rgb, pow(SCREEN_UV.y,2));// + n*0.05,2));
}