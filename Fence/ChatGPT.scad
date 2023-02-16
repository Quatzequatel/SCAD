include <constants.scad>;
include <FencePanel-do.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

// Set the size of the fence posts
post_width = gdv(fence_post, "y");
post_height = gdv(fence_post, "z");

// Set the size of the fence boards
board_width = gdv(fence_4inch_board, "y");
board_height = gdv(fence_4inch_board, "z");

// Set the number of boards in the fence
num_boards = 20;

// Set the gap between boards
gap = convert_in2mm(0.5);

// Create the fence posts
// for (i = [0:num_boards+1]) {
//     translate([i*(board_width+gap), 0, 0]) {
//         cube(size = [post_width, post_width, post_height], center = true);
//     }
// }

// Create the fence boards
for (i = [0:num_boards]) {
    translate([i*(board_width+gap)+post_width, 0, post_height/2]) {
        cube(size = [board_width, board_height, board_width], center = true);
    }
}
