side_x = 28;
side_y = 52;
side_fillet_r = 4;
thickness = 5;

print_lh = 0.2;

tol_xy = 0.1;
tol_z = 0.2;

module __end_params() {}

$fa = 1;
$fs = 0.1;
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
      cut_cylinder(h, r, r_cut);
      translate([-r - mini_val, -r_cut - mini_val, -mini_val]) {
        cube([r + mini_val, 2*(r - r_cut) + 2*mini_val, h + 2*mini_val]);
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
        translate([nx*spacing_x, ny*spacing_y, 0]) cylinder(height, d=phi, false);
      }
    }
  }
}

// half_cut_cylinder(h=3, d=4, r_cut=0.75);
// card();
quarter_cheese_wheel(d=5, r_cut = 1.5);
