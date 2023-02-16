/*
    Data Objects and functions for for FencePanel
*/
include <constants.scad>;
use <convert.scad>;
use <dictionary.scad>;

board_corner_radius = 4.7625;

//Functions
function spacing(spacers, thin_boards, thick_boards) = spacers * convert_in2mm(0.5) + thin_boards * convert_in2mm(1.5) + thick_boards * convert_in2mm(3.5);
function spacing2(spacers, thin_boards, thick_boards) = spacers * convert_in2mm(1.5) + thin_boards * convert_in2mm(1.5) + thick_boards * convert_in2mm(3.5);
function oddInterval(interval) = 1 + interval * 2;

//Data Objects
fence_board = 
[
    "fence board",
    ["x", convert_in2mm(8*12)],
    ["y", convert_in2mm(6*12)],
    ["z", convert_in2mm(3.5)]
];


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
    ["board count", 14],
    ["spacing", convert_in2mm(1)],
    ["center", [convert_in2mm(4*12), 0, 0]],
    ["color", "SaddleBrown"]
];

fence_4inch_board_cap = 
[
    "fence_4inch_board_cap",
    ["x", convert_in2mm(8*12)],
    ["y", convert_in2mm(3.5)],
    ["z", convert_in2mm(1.25)],
    ["color", "SaddleBrown"]
];

fence_2inch_board = 
[
    "fence_2inch_board",
    ["x", convert_in2mm(8*12)],
    ["y", convert_in2mm(1.25)],
    ["z", convert_in2mm(1.5)],
    ["color", "SaddleBrown"]
];

fence_post = 
[
    "fence_post",
    ["x", convert_in2mm(3.5)],
    ["y", convert_in2mm(3.5)],
    ["z", convert_in2mm(72)],
    ["color", "DarkOliveGreen"],
    ["loc Count", 6],
    ["loc 1",[0,0,0]],
    ["loc 2",[gdv(fence_panel, "x"),0,0]],
    ["loc 3",[gdv(fence_panel, "x")*2,0,0]],
    ["loc 4",[gdv(fence_panel, "x")*3,0,0]],
    ["loc 5",[gdv(fence_panel, "x")*4,0,0]],
    ["loc 6",[gdv(fence_panel, "x")*5,0,0]],
    ["vert 1", [0,0,0]],
    ["vert 2", [0,0,convert_in2mm(15.75)]],
    ["vert 3", [0,0,convert_in2mm(15.75 + 11.25)]],
    ["vert 4", [0,0,convert_in2mm(15.75 + 11.25 + 4.75)]],
    ["vert 5", [0,0,convert_in2mm(15.75 + 11.25 + 4.75 + 8.75)]],
    ["vert 6", [0,0,convert_in2mm(15.75 + 11.25 + 4.75 + 8.75 + 4.75)]],
, 
];

fence_post_trim =
[
    "fence_post_trim",
    ["x", convert_in2mm(0.75)],
    ["y", convert_in2mm(0.75)],
    ["z", gdv(fence_post, "z")],
    ["color", "SaddleBrown"],
    ["loc 1", [convert_in2mm(3.5/2), convert_in2mm(0.75)]],
    ["loc 2", [convert_in2mm(3.5/2), -convert_in2mm(1.5)]],     
    ["loc 3", [-convert_in2mm(3.5/2 + 0.75), convert_in2mm(0.75)]],
    ["loc 4", [-convert_in2mm(3.5/2 + 0.75), -convert_in2mm(1.5)]],       
];

brick = 
[
    "brick",
    ["x", convert_in2mm(8)],
    ["y", convert_in2mm(4)],
    ["z", convert_in2mm(2)],
    ["spacing", convert_in2mm(0.5)],
    ["loc", [0, 0, -convert_in2mm(2)]],
    ["color", "Maroon"],
]
