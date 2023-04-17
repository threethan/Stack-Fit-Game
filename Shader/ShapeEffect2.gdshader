shader_type spatial;
render_mode unshaded, blend_add, cull_disabled, depth_draw_always;
uniform vec4 color = vec4(1,1,1,0);
uniform float alpha = 1.0;
uniform float grow = 0.0;


void vertex() {
	COLOR.a = 1.0-abs(NORMAL.y);
	
	
	if (VERTEX.y > 0.0) {
		VERTEX.y = 4.0 * grow;
		COLOR.a *= 0.0;
		//VERTEX.xz *= inner;
	} else {
		VERTEX.y = 0.05;
		//VERTEX.xz *= outer;
	}
}

void fragment() {
	//ALPHA_SCISSOR = 0.1;
	ALPHA = pow(COLOR.a,2.0)*alpha*0.5;
	ALBEDO = color.rgb;
}