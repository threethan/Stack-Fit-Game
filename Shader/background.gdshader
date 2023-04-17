shader_type spatial;
render_mode unshaded;
uniform vec4 base_color_b = vec4(0.55,0.70,0.7,0);
uniform vec4 top_color_b  = vec4(0.75,0.70,0.8,0);

uniform vec4 base_color = vec4(0.5,0.5,0.5,0);
uniform vec4 top_color  = vec4(0.5,0.5,0.5,0);


void fragment() {
	vec3 a1 = mix(base_color.rgb, top_color.rgb, pow(SCREEN_UV.y,2));
	vec3 a2 = mix(base_color_b.rgb, top_color_b.rgb, pow(SCREEN_UV.y,2));
	
	ALBEDO = mix(a1,a2,0.7);
	//ALPHA = 0.7;
}

//
//void fragment() {
//	// Shitty dither pattern
//	vec2 pix = SCREEN_UV * 645644.856;
//	float n = mod(pix.x+pix.y*5.3, 1.0) - 0.5;
//	ALBEDO = mix(base_color.rgb, top_color.rgb, pow(SCREEN_UV.y + n*0.05,2));
//}