shader_type spatial;
render_mode unshaded, blend_add;
uniform float inner = 1.0;
uniform float outer = 1.0;
uniform vec4 color = vec4(1,1,1,0);


void vertex() {
	COLOR.a = 1.0-abs(NORMAL.y);
	if (VERTEX.y > 0.0) {
		VERTEX.xz *= inner;
	} else {
		VERTEX.xz *= outer;
	}
	VERTEX.y = 0.1;
}

void fragment() {
	//ALPHA_SCISSOR = 0.1;
	ALPHA = COLOR.a;
	ALBEDO = color.rgb;
}