include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
$fn = 100;

function spacing(spacers, thin_boards, thick_boards) = spacers * convert_in2mm(1) + thin_boards * convert_in2mm(1.5) + thick_boards * convert_in2mm(3.5);
function oddInterval(interval) = 1 + interval * 2;

fence_panel = 
[
    "fence panel",
    ["x-width", convert_in2mm(8*12)],
    ["y-length", convert_in2mm(6*12)],
    ["z-thickness", convert_in2mm(3.5)]
];

fence_4inch_board = 
[
    "fence_4inch_board",
    ["x-width", convert_in2mm(8*12)],
    ["y-length", convert_in2mm(1.25)],
    ["z-thickness", convert_in2mm(3.5)],
    ["color", "Gray"]
];

fence_2inch_board = 
[
    "fence_2inch_board",
    ["x-width", convert_in2mm(8*12)],
    ["y-length", convert_in2mm(1.25)],
    ["z-thickness", convert_in2mm(1.5)],
    ["color", "DarkKhaki"]
];

fence_post = 
[
    "fence_post",
    ["x-width", convert_in2mm(3.5)],
    ["y-length", convert_in2mm(3.5)],
    ["z-thickness", convert_in2mm(72)],
    ["color", "Gray"]
];

build();

module build(args) 
{
    translate([gdv(fence_4inch_board, "x-width")/2, 0, 0])
    color(gdv(fence_post, "color"), 0.5)
    extrudeZaxis(fence_post);   

    translate([-gdv(fence_4inch_board, "x-width")/2, 0, 0])
    color(gdv(fence_post, "color"), 0.5)
    extrudeZaxis(fence_post);   

    for(i = [0:2])
    {
        color(gdv(fence_4inch_board, "color"), 0.5)
        move_board_up(spacing(spacers = i+1, thin_boards = 0, thick_boards = i))
            extrudeZaxis(fence_4inch_board);        
    }

    move_board_up(spacing(spacers = 3, thin_boards = 0, thick_boards = 3))
    for (i=[0:5]) 
    {
        color(gdv(fence_4inch_board, "color"), 0.5)
        move_board_up(spacing(spacers = i*3 + 1, thin_boards = i*3 - i, thick_boards = i))
            extrudeZaxis(fence_4inch_board);

        color(gdv(fence_2inch_board, "color"), 0.5)
        move_board_up(spacing(spacers = i*3 + 2, thin_boards = i*3 - i, thick_boards = i + 1))
            extrudeZaxis(fence_2inch_board);

        color(gdv(fence_2inch_board, "color"), 0.5)
        move_board_up(spacing(spacers = i*3 + 3, thin_boards = oddInterval(i), thick_boards = i + 1))
            extrudeZaxis(fence_2inch_board);
    }
        
}

module extrudeYaxis(dic)
{
    linear_extrude(gdv(dic, "y-length"))
    square(size = [gdv(dic, "x-width"), gdv(dic, "z-thickness")], center = true);
}

module extrudeZaxis(dic)
{
    linear_extrude(gdv(dic, "z-thickness"))
    square(size = [gdv(dic, "x-width"), gdv(dic, "y-length")], center = true);
}

module move_board_up(height)
{
    echo(height = convert_mm2in(height));
    translate([0,0,height]) 
    children();
}
