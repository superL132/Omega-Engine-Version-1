shader_type canvas_item;

uniform int index_offset;
uniform vec4 colors[11]: source_color;
uniform int array_max = 11;


// 	Swap out the following return_index() funcs to change index shift behavior.

//   LOOPING -- Out-of-range indices are looped around to the other side of the array.
//   Useful for flashing effects. If using negative offset values, start at -15.
int return_index(float raw) { return (int(round(raw * 10.0)) + index_offset) % array_max; }

//   CLAMPING -- Out-of-range indices are clamped to the edges of the array.
//   Useful for fading effects.
// int return_index(float raw) { return min(array_max-1, max(0, (int(round(raw * 10.0)) + index_offset))); }

//   NONE -- Disable index shifting.
//   You can also comment out the index_offset and array_max declarations.
// int return_index(float raw) { return int(round(raw * 10.0)) }


void fragment() {
	float alpha = COLOR.a;
	COLOR = colors[return_index(COLOR.r)]; // Red 25 == COLOR.r .1 == colors[1]
	COLOR.a *= alpha;
}
