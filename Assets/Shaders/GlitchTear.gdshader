shader_type canvas_item;
render_mode unshaded;

uniform sampler2D albedo_texture;

uniform float uv_scale = 1;

uniform float chromatic_abberation : hint_range(.0, .1) = .04;
uniform float noise_size : hint_range(.001, .1) = .01;
uniform float noise_speed = 5.;
uniform float noise_amount : hint_range(0., 1.) = 0.1;

float random(float seed) {
    return fract(sin(dot(vec2(seed, -seed),
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	
	// noise
	if (random((floor(UV.x / noise_size) * noise_size) * (floor(UV.y / noise_size) * noise_size) * floor(TIME * noise_speed) / noise_speed) < noise_amount) {
		discard;
	}

	// multi-sampling for chromatic abberation
	vec4 sample_center = texture(albedo_texture, uv_scale * UV);
	
	vec4 sample_up = texture(
		albedo_texture,
		uv_scale * UV + vec2(chromatic_abberation * (1. + random(TIME)))
	);
		
	vec4 sample_down = texture(
		albedo_texture,
		uv_scale * UV - vec2(chromatic_abberation * (1. + random(TIME + 5.)))
	);

	if (sample_center.a < 0.5 && sample_up.a < 0.5 && sample_down.a < 0.5) {
		discard;
	}

	COLOR = vec4(sample_up.r, sample_center.g, sample_down.b,1.0);
	//ALBEDO = vec3(sample_up.r, sample_center.g, sample_down.b);
}

