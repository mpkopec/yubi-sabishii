/* [General] */
side_x = 28; // .1
side_y = 52; // .1
thickness = 5; // .1

/* [Magnets] */
magnet_diameter = 6.1; // .1
magnet_height = 2.0; // .1
magnet_spacing_x = 15; // .1
magnet_spacing_y = 12; // .1
magnet_count_x = 2;
magnet_count_y = 4;
magnet_z_offset = 1.0; // [0.4:0.2:3.0]

/* [Pattern] */
pattern_height = 2; // .2
pattern_top_x = 10; // .1
pattern_bottom_x = 2; // .1
pattern_count_x = 2;
pattern_top_y = 10; // .1
pattern_bottom_y = 2; // .1
pattern_count_y = 3;

/* [Details] */
print_lh = 0.2; // 0.01

tol_xy = 0.1; // 0.01
tol_z = 0.2; // 0.01

module __end_params() {}

include <BOSL2/std.scad>

$fa = 5;
$fs = 0.5;
mini_val = 0.01;

module cut_cylinder(h=1, r=1, r_cut=0.5, d=undef, center=false) {
  r = (!is_undef(d)) ? d/2 : r;
  z_offset = (center) ? -h/2 : 0;

  translate([0, 0, z_offset]) difference(){
    cylinder(h=h, r=r, center=false);
    translate([-r, r_cut, -mini_val]) cube([2*r, r - r_cut + mini_val, h + 2*mini_val]);
    translate([-r, -r - mini_val, -mini_val]) cube([2*r, r - r_cut + mini_val, h + 2*mini_val]);
  };
}

module half_cut_cylinder(h=1, r=1, r_cut=0.5, d=undef) {
  r = (!is_undef(d)) ? d/2 : r;

  translate([0, r_cut, 0]){
    difference(){
      cut_cylinder(h=h, r=r, r_cut=r_cut);
      translate([-r - mini_val, -r_cut - mini_val, -mini_val]) {
        cube([r + mini_val, 2*r_cut + 2*mini_val, h + 2*mini_val]);
      }
    }
  }
}

module cheese_wheel(r=1, r_cut=0.5, d=undef) {
  r = (!is_undef(d)) ? d/2 : r;

  difference(){
    sphere(r=r);
    translate([ r_cut, -r, -r - mini_val]) cube([r - r_cut + mini_val, 2*r, 2*r + 2*mini_val]);
    translate([-r - mini_val, -r, -r - mini_val]) cube([r - r_cut + mini_val, 2*r, 2*r + 2*mini_val]);
  };
}

module quarter_cheese_wheel(r=1, r_cut=0.5, d=undef) {
  r = (!is_undef(d)) ? d/2 : r;

  translate([0, 0, r_cut]){
    difference(){
      rotate([0, 90, 0]) cheese_wheel(r, r_cut);
      translate([-r - mini_val, -r - mini_val, -r_cut - mini_val]) cube([r + mini_val, 2*r + 2*mini_val, 2*r_cut + 2*mini_val]);
      translate([-mini_val, -r - mini_val, -r_cut - mini_val]) cube([r + 2*mini_val, r + mini_val, 2*r_cut + 2*mini_val]);
    }
  }
}

module magnet_array(phi, height, spacing_x, spacing_y, count_x, count_y) {
  translate([-(count_x - 1)*spacing_x/2, -(count_y - 1)*spacing_y/2, 0]) {
    for (nx = [0:count_x - 1]) {
      for (ny = [0:count_y - 1]) {
        translate([nx*spacing_x, ny*spacing_y, 0]) cylinder(h=height, d=phi, center=false);
      }
    }
  }
}

// quarter_cheese_wheel(d=5, r_cut = 1.5);

r_cut = thickness/2;
r = r_cut/cos(45);
r_cut_triangle_h = sqrt(r*r - r_cut*r_cut);

side_y_midpart = side_y - 2*r;
side_x_midpart = side_x - 2*r;

pattern_y_0 = -side_y_midpart/2 - r_cut_triangle_h;
pattern_y_1 = side_y_midpart/2 + r_cut_triangle_h;
pattern_y_filled = pattern_count_y*pattern_top_y;
pattern_y_empty = abs(pattern_y_1 - pattern_y_0) - pattern_y_filled;
pattern_y_empty_dy = pattern_y_empty/(pattern_count_y + 1);
pattern_y_dy = pattern_y_empty_dy + pattern_top_y;
pattern_y_vals = (pattern_count_y == 1) ? [0] : [pattern_y_0 + pattern_y_dy - pattern_top_y/2:pattern_y_dy:pattern_y_1 - pattern_y_dy + pattern_top_y/2];

pattern_x_0 = -side_x_midpart/2 - r_cut_triangle_h;
pattern_x_1 = side_x_midpart/2 + r_cut_triangle_h;
pattern_x_filled = pattern_count_x*pattern_top_x;
pattern_x_empty = abs(pattern_x_1 - pattern_x_0) - pattern_x_filled;
pattern_x_empty_dy = pattern_x_empty/(pattern_count_x + 1);
pattern_x_dy = pattern_x_empty_dy + pattern_top_x;
pattern_x_vals = (pattern_count_x == 1) ? [0] : [pattern_x_0 + pattern_x_dy - pattern_top_x/2:pattern_x_dy:pattern_x_1 - pattern_x_dy + pattern_top_x/2];

difference(){
  %difference(){
    translate([-side_x_midpart/2, -side_y_midpart/2, 0]) union(){
      rotate([90, 0, 180]) half_cut_cylinder(h=side_y_midpart, r=r, r_cut=r_cut);
      translate([side_x_midpart, side_y_midpart, 0]) rotate([90, 0, 0]) half_cut_cylinder(h=side_y_midpart, r=r, r_cut=r_cut);
      translate([0, side_y_midpart, 0]) rotate([90, 0, 90]) half_cut_cylinder(h=side_x_midpart, r=r, r_cut=r_cut);
      translate([side_x_midpart, 0, 0]) rotate([90, 0, -90]) half_cut_cylinder(h=side_x_midpart, r=r, r_cut=r_cut);

      rotate([0, 0, -180]) quarter_cheese_wheel(r=r, r_cut=r_cut);
      translate([side_x_midpart, 0, 0]) rotate([0, 0, -90]) quarter_cheese_wheel(r=r, r_cut=r_cut);
      translate([side_x_midpart, side_y_midpart, 0]) rotate([0, 0, 0]) quarter_cheese_wheel(r=r, r_cut=r_cut);
      translate([0, side_y_midpart, 0]) rotate([0, 0, 90]) quarter_cheese_wheel(r=r, r_cut=r_cut);

      translate([-mini_val, -mini_val, 0])cube([side_x_midpart + 2*mini_val, side_y_midpart + 2*mini_val, thickness]);
    };

    if (pattern_count_x > 0) {
      for (pnx = pattern_x_vals) {
        translate([pnx, 0, thickness - pattern_height + mini_val]) 
        prismoid(size1=[pattern_bottom_x, side_y],
                 size2=[pattern_top_x, side_y],
                 h=pattern_height + mini_val
        );
      }
    }

    if (pattern_count_y > 0) {
      for (pny = pattern_y_vals) {
        translate([0, pny, thickness - pattern_height + mini_val]) 
        prismoid(size1=[side_x, pattern_bottom_y],
                 size2=[side_x, pattern_top_y],
                 h=pattern_height + mini_val
        );
      }
    }
  };

  translate([0, 0, magnet_z_offset]) magnet_array(magnet_diameter, magnet_height, magnet_spacing_x, magnet_spacing_y, magnet_count_x, magnet_count_y);
};

