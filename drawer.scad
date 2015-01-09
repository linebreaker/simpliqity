
use <boxjoint.scad>;
use <params.scad>;

params = [
	["width",              30],
	["depth",              15],
	["height",             10],
	["finger_length",      2],
	["spacing",            2],
	["pull_hole_radius",   1],
];

module drawer(dimensions, params=[]) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	spacing = param_value(params, "spacing");

	// These variables control the joint types used for every joint
	// on the drawer. The naming convention is: joint_{face}_{joint}.
	// For example, joint_bottom_front is the joint on the bottom
	// face that joins to the front face. If this is set to "inner",
	// that implies that the joint on the front face that joins to
	// the bottom becomes the opposite ("outer").
	joint_bottom_front = "inner";
	joint_bottom_back = "inner";
	joint_bottom_left = "inner";
	joint_bottom_right = "inner";
	joint_front_left = "inner";
	joint_front_right = "inner";
	joint_back_left = "inner";
	joint_back_right = "inner";

	joint_front_bottom = box_joint_opposite(joint_bottom_front);
	joint_back_bottom = box_joint_opposite(joint_bottom_back);
	joint_left_bottom = box_joint_opposite(joint_bottom_left);
	joint_right_bottom = box_joint_opposite(joint_bottom_right);
	joint_left_front = box_joint_opposite(joint_front_left);
	joint_right_front = box_joint_opposite(joint_front_right);
	joint_left_back = box_joint_opposite(joint_back_left);
	joint_right_back = box_joint_opposite(joint_back_right);

	// Back
	translate([height + spacing, height + depth + spacing * 2])
		box_side([width, height], [joint_back_bottom,
		         "none", joint_back_left, joint_back_right],
		         params);
	// Bottom
	translate([height + spacing, height + spacing])
		box_side([width, depth], [joint_bottom_front,
		         joint_bottom_back, joint_bottom_left,
		         joint_bottom_right], params);
	// Front
	translate([height + spacing, 0]) {
		difference() {
			box_side([width, height], ["none", joint_front_bottom,
				 joint_front_left, joint_front_right], params);
			translate([width / 2, height / 2])
				circle(param_value(params, "pull_hole_radius"));
		}
	}
	// Left side
	translate([0, height + spacing])
		box_side([height, depth], [joint_left_front, joint_left_back,
		         "none", joint_left_bottom], params);
	// Right side
	translate([height + width + spacing * 2, height + spacing])
		box_side([height, depth], [joint_right_front, joint_right_back,
		         joint_right_bottom, "none"], params);
}

drawer([param_value(params, "width"), param_value(params, "depth"),
        param_value(params, "height")], params);

