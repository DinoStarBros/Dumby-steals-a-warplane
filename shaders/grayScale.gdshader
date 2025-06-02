shader_type canvas_item;

void fragment() {
	vec4 input_col = texture(TEXTURE, UV);
	
	float color_avg = (input_col.r + input_col.g + input_col.b) / 3.0;
	// Gets the average of the colors
	// To make a grayscale effect
	
	vec4 output_col = vec4(
		color_avg, color_avg, color_avg, input_col.a
	);
	
	COLOR = output_col;
}