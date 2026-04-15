shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float shake_frequency : hint_range(0.0, 1.0) = 0.1;
uniform float scanline_opacity : hint_range(0, 0.1) = 0.04;
uniform float scanline_size : hint_range(50, 500) = 400;
uniform float color_glitch_intensity : hint_range(0, 0.01) = 0.003;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    if (rand(vec2(TIME, 0.0)) < shake_frequency) {
        uv.x += rand(vec2(TIME, uv.y)) * 0.01;
    }

    float r = texture(SCREEN_TEXTURE, uv + vec2(color_glitch_intensity, 0.0)).r;
    float g = texture(SCREEN_TEXTURE, uv).g;
    float b = texture(SCREEN_TEXTURE, uv - vec2(color_glitch_intensity, 0.0)).b;
    
    float scanline = sin(uv.y * scanline_size) * scanline_opacity;
    COLOR = vec4(r - scanline, g - scanline, b - scanline, 1.0);
}
