/*
    Data Objects and functions for for FencePanel
*/

use <convert.scad>;
use <dictionary.scad>;

//Functions
function spacing(spacers, thin_boards, thick_boards) = spacers * convert_in2mm(0.5) + thin_boards * convert_in2mm(1.5) + thick_boards * convert_in2mm(3.5);
function spacing2(spacers, thin_boards, thick_boards) = spacers * convert_in2mm(1.5) + thin_boards * convert_in2mm(1.5) + thick_boards * convert_in2mm(3.5);
function oddInterval(interval) = 1 + interval * 2;

//Data Objects
fence_panel = 
[
    "fence panel",
    ["x", convert_in2mm(8*12)],
    ["y", convert_in2mm(6*12)],
    ["z", convert_in2mm(3.5)]
];

fence_4inch_board = 
[
    "fence_4inch_board",
    ["x", convert_in2mm(8*12)],
    ["y", convert_in2mm(1.25)],
    ["z", convert_in2mm(3.5)],
    ["color", "Gray"]
];

fence_4inch_board_cap = 
[
    "fence_4inch_board_cap",
    ["x", convert_in2mm(8*12)],
    ["y", convert_in2mm(3.5)],
    ["z", convert_in2mm(1.25)],
    ["color", "Gray"]
];

fence_2inch_board = 
[
    "fence_2inch_board",
    ["x", convert_in2mm(8*12)],
    ["y", convert_in2mm(1.25)],
    ["z", convert_in2mm(1.5)],
    ["color", "DarkKhaki"]
];

fence_post = 
[
    "fence_post",
    ["x", convert_in2mm(3.5)],
    ["y", convert_in2mm(3.5)],
    ["z", convert_in2mm(72)],
    ["color", "Gray"],
    ["loc east",[-gdv(fence_panel, "x")/2,0,0]],
    ["loc west",[gdv(fence_panel, "x")/2,0,0]],
];

fence_post_trim =
[
    "fence_post_trim",
    ["x", convert_in2mm(0.75)],
    ["y", convert_in2mm(0.75)],
    ["z", convert_in2mm(72)],
    ["color", "white"],
    ["loc 1", [convert_in2mm(3.5/2), convert_in2mm(0.75)]],
    ["loc 2", [convert_in2mm(3.5/2), -convert_in2mm(1.5)]],     
    ["loc 3", [-convert_in2mm(3.5/2 + 0.75), convert_in2mm(0.75)]],
    ["loc 4", [-convert_in2mm(3.5/2 + 0.75), -convert_in2mm(1.5)]],       
];
