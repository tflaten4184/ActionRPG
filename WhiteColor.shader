shader_type canvas_item;

uniform bool active = false;

void fragment() { // executes for every single pixel
	vec4 previous_color = texture(TEXTURE, UV); // color currently at current pixel on current texture (sprite)
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a); // New color Red Green Blue Alpha
	vec4 new_color = previous_color;
	if (active) {
		new_color = white_color;
	}
	COLOR = new_color; 
}