use <boxjoint.scad>;
use <kerf.scad>;
use <params.scad>;

CD_JEWEL_CASE = [125, 142, 10];
DVD_CASE = [190, 135, 15];

$params = [
	["num_shelves",        10],
	["dimensions",         CD_JEWEL_CASE],
	["tab_inset",          20],
	["tab_length",         20],
	["tab_depth",          20],
	["tab_flange",         10],
	["kerf",               0],
	["thickness",          3.175],
	["spacing",            20],
];

module tower_side(num_shelves, dimensions) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	thickness = param_value("thickness");
	tab_length = param_value("tab_length");
	tab_inset = param_value("tab_inset");

	tower_height = num_shelves * (height + thickness)
	             + thickness;

	difference() {
		box_face([depth + thickness, tower_height],
		         ["inner", "outer", "inner", "none"]);

		for (i = [1:num_shelves-1]) {
			translate([tab_inset, i * (height + thickness)])
				square([tab_length, thickness]);
			translate([depth - tab_inset - tab_length,
			           i * (height + thickness)])
				square([tab_length, thickness]);
		}
	}
}

module tower_back(num_shelves, dimensions) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	thickness = param_value("thickness");

	tower_height = num_shelves * (height + thickness)
	             + thickness;

	box_face([width + thickness * 2, tower_height],
	         ["inner", "inner", "inner", "inner"]);
}

module shelf_tab() {
	thickness = param_value("thickness");
	tab_length = param_value("tab_length");
	tab_depth = param_value("tab_depth");
	tab_flange = param_value("tab_flange");
	fn = param_value("circle_detail");

	union() {
		translate([0, tab_flange])
			square([thickness, tab_length]);

		translate([thickness, 0]) {
			scale([tab_depth, tab_flange + tab_length / 2]) {
				intersection() {
					translate([0, 1]) circle(1, $fn=fn);
					translate([0, 0]) square([1, 2]);
				}
			}
		}
	}
}

module tower(num_shelves, dimensions) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	thickness = param_value("thickness");
	spacing = param_value("spacing");
	tab_length = param_value("tab_length");
	tab_depth = param_value("tab_depth");
	tab_flange = param_value("tab_flange");

	// Left side:
	translate([spacing, spacing])
	tower_side(num_shelves, dimensions);

	// Back:
	translate([depth + thickness + spacing * 2, spacing])
		tower_back(num_shelves, dimensions);

	// Right side:
	translate([width + depth * 2 + thickness * 4 + spacing * 3, spacing])
		scale([-1, 1, 1])
			tower_side(num_shelves, dimensions);

	// Top and bottom:
	translate([width + depth * 2 + thickness * 4 + spacing * 4, spacing]) {
		box_face([width + thickness, depth + thickness],
		         ["outer", "outer", "none", "outer"]);
		translate([0, depth + thickness + spacing])
			box_face([width + thickness, depth + thickness],
			         ["outer", "outer", "none", "outer"]);
	}

	// Tabs
	translate([width * 2 + depth * 2 + thickness * 6 + spacing * 5,
	           spacing]) {
		for (i = [0:num_shelves-1]) {
			translate([0, i * (tab_length + tab_flange * 2 + spacing)]) {
				shelf_tab();
				translate([tab_depth + thickness + spacing, 0])
					shelf_tab();
			}
		}
	}
}

kerf_apply() {
	tower(param_value("num_shelves"), param_value("dimensions"));
}

