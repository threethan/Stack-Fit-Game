shader_type spatial;
render_mode unshaded;
uniform float shapeheight = 1.0;
uniform vec4 base_color = vec4(0.5,0.5,0.5,0);
uniform vec4 top_color  = vec4(0.5,0.5,0.5,0);

uniform float alpha = 0.0;
uniform float fade = 1.0;

const float lighting_amount = 0.17;

uniform bool dark_theme = false;

const bool translucency = false;

void vertex() {
	//Fake lighting
	if (translucency) {
		if (dark_theme) {
			COLOR.rgb = (NORMAL.z - NORMAL.x/3.0) * -vec3(0.10, 0.05, 0.05) + NORMAL.x * -vec3(-0.01, 0.03, -0.02) + vec3(0.065);
			COLOR.rgb *= alpha * fade * lighting_amount * (VERTEX.y+0.15) * 0.8;
			}
		else {
			COLOR.rgb = (NORMAL.z - NORMAL.x/3.0) * -vec3(0.10, 0.05, 0.05) + NORMAL.x * -vec3(-0.01, 0.03, -0.02) - vec3(0.19);
		COLOR.rgb *= alpha * fade * lighting_amount * (VERTEX.y+0.25);
		}
	}
	
	COLOR.a = NORMAL.y;
	
	if (VERTEX.y <= 0.1) {
		VERTEX.y = -0.05;
		VERTEX.xz *= 1.05;
	}
	VERTEX.y -= shapeheight;
}

void fragment() {
	// Shitty dither pattern
	vec2 pix = SCREEN_UV * 645644.856;
	float n = mod(pix.x+pix.y*5.3, 1.0) - 0.5;
	
	ALPHA_SCISSOR = 0.1;
	ALPHA = float(COLOR.a==0.0);
	if (translucency)
		ALBEDO = mix(base_color.rgb, top_color.rgb, pow(SCREEN_UV.y,2)+0.05*n) + COLOR.rgb;
	else
		ALBEDO = mix(base_color.rgb, top_color.rgb, pow(SCREEN_UV.y,2)+0.05*n);
}