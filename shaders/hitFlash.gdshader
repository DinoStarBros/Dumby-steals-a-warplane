shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
// Made it uniform so you can choose whatever 
// color you want for the hitflash
uniform float mix_value = 0.0;

void fragment() {
	vec4 input_color = texture(TEXTURE,UV);
	// Grabs the texture's texture & uv coordinates
	// Basically a vec4 copy of the texture
	
	vec4 output_color = vec4(
		flash_color.r, 
		flash_color.g, 
		flash_color.b, 
		input_color.a
		);
		// It flashes white on the 1st 3, but not the 4th
		// So that it doesn't include transparent parts
		// (The corners in this case)
	
	COLOR = mix(input_color, output_color, mix_value);
}
