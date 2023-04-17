shader_type canvas_item;

void fragment() {
	vec2 dist = UV - vec2(0.5,0.5);
	if(texture(TEXTURE, UV).rgb == vec3(1.0, 0.0, 0.0)) {
		if (abs(dist.x) + abs(dist.y) <= 0.5) {
			COLOR = vec4(1);
		} else {
			COLOR = vec4(0);
		}
	}
	if(texture(TEXTURE, UV).rgb == vec3(0.0, 1.0, 0.0)) {
		if (abs(dist.x) + abs(dist.y) <= 0.5) {
			COLOR = vec4(0.5);
			COLOR.a = 1.0;
		} else {
			COLOR = vec4(0);
		}
	}
}