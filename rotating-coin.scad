/* [General] */
// Which part to generate
which = "all"; // [bottom, top, all]
// The diameter of the whole assembly
diameter = 39.0; // .1
// The thickness of one half of the assembly
thickness = 3.6; // .1

/* [Magnets] */
// The diameter of a single magnet
magnet_diameter = 6.1; // .1
// The height of a single magnet
magnet_height = 1.0; // .1
// Total number of magnets in one side of the assembly
magnet_count = 8;
// The distance between the magnets when the assembly is together
magnet_distance = 1.0; // [0.4:0.2:2.0]

/* [Details] */
// The diameter of the top "pin"
top_pin_diameter = 8.0; // .1

// Layer height
print_lh = 0.2; // .01

// Assumed XY tolerance
tol_xy = 0.1; // .01
// Assumed Z tolerance
tol_z = 0.2; // .01

module end_params(){}
mini_value = 0.01;

function x_from_polar(r, theta) = r*cos(theta);
function y_from_polar(r, theta) = r*sin(theta);

module magnet_array(external_diameter, magnet_diameter, magnet_height, magnet_count, center = false) {
  for (n = [1:magnet_count]) {
    r = external_diameter/2 - magnet_diameter/2;
    theta = n*(360/magnet_count);
    translate([x_from_polar(r, theta), y_from_polar(r, theta), 0]) cylinder(magnet_height, d=magnet_diameter, center=center);
  }
}

module bottom_nomag(bottom_diameter, top_diameter, thickness) {
  thickness_print = floor(thickness/print_lh)*print_lh;

  union(){
    translate([0, 0, -thickness_print]) cylinder(thickness_print, d=bottom_diameter);
    cylinder(thickness_print, d=top_diameter);
  };
}

module top_nomag(bottom_diameter, top_diameter, thickness) {
  thickness_print = floor(thickness/print_lh)*print_lh;

  difference(){
    cylinder(thickness_print, d=bottom_diameter);
    translate([0, 0, -mini_value]) cylinder(thickness_print + 2*mini_value, d=top_diameter + tol_xy*1.5);
  };
}

module bottom () {
  magnet_distance_print = ceil(magnet_distance/print_lh);
  magnet_z_offset = -(magnet_height + ceil(magnet_distance_print/2)*print_lh);
  echo("bottom magnet_z_offset is ", magnet_z_offset);

  difference(){
    bottom_nomag(diameter, top_pin_diameter, thickness);
    translate([0, 0, magnet_z_offset]) magnet_array(diameter - 2, magnet_diameter, magnet_height, magnet_count);
  };
}

module top () {
  magnet_distance_print = ceil(magnet_distance/print_lh);
  magnet_z_offset = floor(magnet_distance_print/2)*print_lh;
  echo("top magnet_z_offset is ", magnet_z_offset);

  difference(){
    top_nomag(diameter, top_pin_diameter, thickness);
    translate([0, 0, magnet_z_offset]) magnet_array(diameter - 2, magnet_diameter, magnet_height, magnet_count);
  };
}

// The value, after which, another straigh line needs to be drawn, when approximating
// circles.
$fs = 0.3;
$fa = 2;

if (which == "bottom" || which == "all") {
  bottom();
}

if (which == "top" || which == "all") {
  top();
}

