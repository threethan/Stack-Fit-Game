shader_type spatial;
render_mode unshaded, blend_mul;
uniform float inner = 0.4;
uniform float outer = 0.99;
const float amount = 0.08;

uniform float shapeheight = 0.0;

void vertex() {
	// Fake AO?
	COLOR.a = 1.0-abs(NORMAL.y);
	if (VERTEX.y > 0.0) {
		VERTEX.xz *= inner;
		COLOR.r = 0.0;
	} else {
		VERTEX.xz *= outer;
		COLOR.r = 1.0;
	}
	VERTEX.y = 0.0;//-shapeheight+0.025;
	if (shapeheight==0.0) {
		COLOR.a = 0.0;
	}
}

void fragment() {
	//ALPHA_SCISSOR = 0.1;
	//ALPHA = COLOR.a;
	ALBEDO = vec3(1.0 - COLOR.r*COLOR.r * amount);
}