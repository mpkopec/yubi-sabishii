side_x = 28;
side_y = 52;

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
magnet_array(6, 2, 10, 12, 2, 4);
