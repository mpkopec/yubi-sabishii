/* [General] */
// The diameter of the whole assembly
diameter = 39.0; // .1
// The thickness of one half of the assembly
thickness = 3.6; // .1

/* [Magnets] */
magnet_pattern_diameter = 34; // .1
// The diameter of a single magnet
magnet_diameter = 6.1; // .1
// The height of a single magnet
magnet_height = 1.0; // .1
// Total number of magnets in one side of the assembly
magnet_count = 8;
// The distance between the magnets when the assembly is together
magnet_distance = 0.4; // [0.4:0.2:2.0]

/* [Details] */
// Layer height
print_lh = 0.2; // .01

// Assumed XY tolerance
tol_xy = 0.1; // .01
// Assumed Z tolerance
tol_z = 0.2; // .01

module end_params(){}
mini_value = 0.01;

include <BOSL2/std.scad>

function x_from_polar(r, theta) = r*cos(theta);
function y_from_polar(r, theta) = r*sin(theta);

module magnet_array(external_diameter, magnet_diameter, magnet_height, magnet_count, center = false) {
  for (n = [1:magnet_count]) {
    r = external_diameter/2 - magnet_diameter/2;
    theta = n*(360/magnet_count);
    translate([x_from_polar(r, theta), y_from_polar(r, theta), 0]) cylinder(magnet_height, d=magnet_diameter, center=center);
  }
  cylinder(magnet_height, d=magnet_diameter, center=center);
}

module nomag(diameter, thickness) {
  thickness_print = floor(thickness/print_lh)*print_lh;

  cyl(l=thickness_print, d=diameter, chamfer=3*print_lh, anchor=BOTTOM);
}

module top () {
  magnet_distance_print = ceil(magnet_distance/print_lh);
  magnet_z_offset = floor(magnet_distance_print)*print_lh;
  echo("top magnet_z_offset is ", magnet_z_offset);

  difference(){
    %nomag(diameter, thickness);
    translate([0, 0, magnet_z_offset]) magnet_array(magnet_pattern_diameter, magnet_diameter, magnet_height, magnet_count);
  };
}

// The value, after which, another straigh line needs to be drawn, when approximating
// circles.
$fs = 0.3;
$fa = 2;

top();

