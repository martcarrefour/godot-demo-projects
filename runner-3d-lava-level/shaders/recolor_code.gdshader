shader_type canvas_item;
uniform vec4 color:source_color;


void fragment() {
	vec3 color_without_green =  COLOR.rgb * vec3(0,0,1);
	float amount_of_red_and_blue = length(color_without_green);
	float red_and_blue_mask = step(0.01, amount_of_red_and_blue);
	vec3 retained_color = COLOR.rgb * red_and_blue_mask;
	float green_mask =( 1.0 - red_and_blue_mask) * COLOR.b;

	vec3 masked_replacement_color = retained_color * green_mask;
	vec3 final_color = retained_color + masked_replacement_color;
	COLOR.rgb =vec3(final_color) ;

}

