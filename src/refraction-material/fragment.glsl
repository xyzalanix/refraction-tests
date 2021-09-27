uniform sampler2D envMap;
uniform vec2 resolution;

varying vec3 worldNormal;
varying vec3 viewDirection;

float ior = 1.5;

vec3 reflectionColor = vec3(1.0);

float fresnelFunc(vec3 viewDirection, vec3 worldNormal) {
	return pow( 1.0 + dot( viewDirection, worldNormal), 3.0 );
}

void main() {
	// screen coordinates
	vec2 uv = gl_FragCoord.xy / resolution;

	// combine backface and frontface normal
	vec3 normal = worldNormal;

	// calculate refraction and apply to uv
	vec3 refracted = refract(viewDirection, normal, 1.0/ior);
	uv += refracted.xy;

	// sample environment texture
	vec4 tex = texture2D(envMap, uv);

	// calculate fresnel
	float fresnel = fresnelFunc(viewDirection, normal);

	vec4 color = tex;

	// apply fresnel
	color.rgb = mix(color.rgb, reflectionColor, fresnel);

	gl_FragColor = vec4(color.rgb, 1.0);
}