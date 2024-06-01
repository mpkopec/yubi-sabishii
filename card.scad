side_x = 28;
side_y = 52;
side_fillet_r = 4;
thickness = 5;

print_lh = 0.2;

tol_xy = 0.1;
tol_z = print_lh;

module magnet_array(phi, height, spacing_x, spacing_y, count_x, count_y) {
  translate([-(count_x - 1)*spacing_x/2, -(count_y - 1)*spacing_y/2, 0]) {
    for (nx = [0:count_x - 1]) {
      for (ny = [0:count_y - 1]) {
        translate([nx*spacing_x, ny*spacing_y, 0]) cylinder(height, d=phi, false);
      }
    }
  }
}

module card () {
  // This works well and good, but has no nice fileting on the sides
  // union(){
  //   cube([side_x - 2*side_fillet_r, side_y, thickness], true);
  //   cube([side_x, side_y - 2*side_fillet_r, thickness], true);
  //   for (i = [-1:2:1]) {
  //     for (j = [-1:2:1]) {
  //       translate([i*(side_x/2 - side_fillet_r), j*(side_y/2 - side_fillet_r), 0]) 
  //         cylinder(thickness, r=side_fillet_r, center=true);
  //     }
  //   }
  // };
  union(){
    translate([-side_x/2 + side_fillet_r, 0, 0]) {
      rotate([90, 0, 0]) 
        cylinder(side_y - 2*side_fillet_r, r=side_fillet_r, center=true);
      translate([0, -side_y/2 + side_fillet_r, 0])
        sphere(r=side_fillet_r);
      translate([0, side_y/2 - side_fillet_r, 0])
        sphere(r=side_fillet_r);
    }
  };
}

card();
