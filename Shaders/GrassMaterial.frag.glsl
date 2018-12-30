#version 450

#include "../compiled.inc"

in vec3 color;
in vec4 lightPos;

out vec4 fragColor;

uniform sampler2DShadow shadowMap;

float PCF(const vec2 uv, const float compare, const vec2 smSize) {
	float result = texture(shadowMap, vec3(uv + (vec2(-1.0, -1.0) / smSize), compare));
	result += texture(shadowMap, vec3(uv + (vec2(-1.0, 0.0) / smSize), compare));
	result += texture(shadowMap, vec3(uv + (vec2(-1.0, 1.0) / smSize), compare));
	result += texture(shadowMap, vec3(uv + (vec2(0.0, -1.0) / smSize), compare));
	result += texture(shadowMap, vec3(uv, compare));
	result += texture(shadowMap, vec3(uv + (vec2(0.0, 1.0) / smSize), compare));
	result += texture(shadowMap, vec3(uv + (vec2(1.0, -1.0) / smSize), compare));
	result += texture(shadowMap, vec3(uv + (vec2(1.0, 0.0) / smSize), compare));
	result += texture(shadowMap, vec3(uv + (vec2(1.0, 1.0) / smSize), compare));
	return result / 9.0;
}

void main() {
	vec3 lPos = lightPos.xyz / lightPos.w;
    const float shadowsBias = 0.001;
    float visibility = max(PCF(lPos.xy, lPos.z - shadowsBias, shadowmapSize), 0.45);
	fragColor = vec4(color * visibility, 1.0);
}
