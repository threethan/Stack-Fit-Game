shader_type spatial;
render_mode unshaded, blend_mul;
uniform float inner = 0.95;
uniform float outer = 2.0;
uniform float amount = 1.0;

void vertex() {
	COLOR.a = 1.0-abs(NORMAL.y)*5.0;
	if (VERTEX.y != 0.0) {
		VERTEX.xz *= inner;
		COLOR.r = 1.0;
	} else {
		VERTEX.xz *= outer;
		COLOR.r = 0.0;
	}
	VERTEX.y = 0.035;
}

void fragment() {
	ALPHA_SCISSOR = 0.1;
	ALPHA = clamp(COLOR.a, 0, 1);
	ALBEDO = clamp(vec3(1.0-COLOR.r*COLOR.r*COLOR.r * amount* COLOR.a),0,1);
	if (ALBEDO.r < 0.1)
		ALBEDO = vec3(1);
}