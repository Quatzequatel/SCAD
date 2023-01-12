/*
    Build interweaving grid paddern
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
$fn = 100;

board2x2 = 
[
    "board2x2",
    ["x", convert_in2mm(1.5)],
    ["y", convert_in2mm(1.5)],
    ["z", convert_in2mm(8*12)],
    ["spacing", convert_in2mm(4.125)],
    ["move", [0, 0,  -convert_in2mm(8*12)/2]],
    ["rotate", [ 0, 90, 0] ],
    ["color", "brown"]
];

crossboard =
[
    "crossboard",
    ["x", convert_in2mm(1.5)],
    ["y", convert_in2mm(1.5)],
    ["z", convert_in2mm(18)],
    ["spacing", convert_in2mm(4)],
    ["move", [0, 0,  -convert_in2mm(18)/2]],
    ["rotate", [ 90, 0, 0] ],
    ["color", "red"]
];

cutout2x2 = 
[
    "cut out cube",
    ["x", convert_in2mm(2 * 0.76)],
    ["y", convert_in2mm(2 * 0.76)],
    ["z", convert_in2mm(0.77)],
    ["move", [0, 0,  -convert_in2mm(0.76)]],
    ["color", "white"]
];

cutouts = 
[
    "list of cutouts",
    ["1", convert_in2mm(4)],
    ["2", convert_in2mm(2 * 4)],
    ["3", convert_in2mm(3 * 4)],
    ["4", convert_in2mm(4 * 4)],
    ["5", convert_in2mm(5 * 4)],
    ["6", convert_in2mm(6 * 4)],
];

build(cutouts);

module build(list)
{
    for(b = [0:4])
    {
        translate([0, b * gdv(board2x2, "spacing"),0])
        translate([0, 0, convert_in2mm(1.5)])
        difference()
        {
            draw_board2x2();
            for(i = [-12:12])
            {
                translate([i * gdv(list, "1"), 0, 0])
                draw_cutout_2x2();
            }        
        }
    }


    for(i = [-12 : 12])
    {
        translate([i * gdv(crossboard, "spacing"), gdv(crossboard, "z")/2 ,0])
        draw_cross_board();
    }
}

module draw_board2x2()
{
    applyColor(board2x2, 0.5)
    applyRotate(board2x2)
    applyMove(board2x2)
    // moveToCenter(board2x2)
    drawCube(board2x2);
}

module draw_cross_board()
{
    applyColor(crossboard, 0.5)
    applyRotate(crossboard)
    applyMove(crossboard)
    // moveToCenter(crossboard)
    drawCube(crossboard);    
}

module draw_cutout_2x2()
{
    applyColor(cutout2x2, 0.05)
    // moveToCenter(cutout2x2)
    applyMove(cutout2x2)
    drawCube(cutout2x2);
}