shader_type spatial;

uniform sampler2D albedo_tex : source_color, filter_nearest;
uniform float aging_strength : hint_range(0.0, 1.0, 0.01) = 0.4;
uniform float noise_scale : hint_range(32.0, 128.0, 0.5) = 128.0;
uniform vec3 aging_color : source_color = vec3(0.55, 0.45, 0.25); 
uniform float roughness : hint_range(0.0, 1.0) = 0.8;
uniform vec2 seed = vec2(0.0, 0.0);
uniform ivec2 texture_size = ivec2(16, 16);

float random(vec2 pos) {
    return fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 pos) {
    return random(floor(pos));
}

float value_noise(vec2 pos) {
    vec2 p = floor(pos);
    vec2 f = fract(pos);
    float v00 = noise(p + vec2(0.0, 0.0));
    float v10 = noise(p + vec2(1.0, 0.0));
    float v01 = noise(p + vec2(0.0, 1.0));
    float v11 = noise(p + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(v00, v10, u.x), mix(v01, v11, u.x), u.y);
}

float aging_noise(vec2 uv) {
    return (
        value_noise(uv * noise_scale * 0.5)  * 0.40
      + value_noise(uv * noise_scale)         * 0.30
      + value_noise(uv * noise_scale * 2.0)   * 0.20
      + value_noise(uv * noise_scale * 4.0)   * 0.10
    );
}

void fragment() {
    vec2 snapped_uv = floor(UV * vec2(texture_size)) / vec2(texture_size);

    vec4 base = texture(albedo_tex, UV);
    float n = aging_noise(snapped_uv + seed);

    float dirt = smoothstep(0.3, 0.6, 1.0 - n) * aging_strength;

    vec3 aged = mix(base.rgb, aging_color, n * aging_strength * 0.5);

    aged = mix(aged, aged * 0.4, dirt);

    ALBEDO = aged;
    ROUGHNESS = roughness + n * 0.2;
    METALLIC = 0.0;
}