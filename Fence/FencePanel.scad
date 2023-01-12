include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <FencePanel-do.scad>;
$fn = 100;

function spacing(spacers, thin_boards, thick_boards) = spacers * convert_in2mm(0.5) + thin_boards * convert_in2mm(1.5) + thick_boards * convert_in2mm(3.5);
function spacing2(spacers, thin_boards, thick_boards) = spacers * convert_in2mm(1.5) + thin_boards * convert_in2mm(1.5) + thick_boards * convert_in2mm(3.5);
function oddInterval(interval) = 1 + interval * 2;

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

build();

module build(args) 
{


    draw_post_pair(fence_post, fence_post_trim);

    draw_horizontal_boards();

}

module draw_horizontal_boards()
{
    for(i = [0:2])
    {
        // color(gdv(fence_4inch_board, "color"), 0.9)
        applyColor(fence_4inch_board, 0.9)
        move_board_up(spacing(spacers = i+1, thin_boards = 0, thick_boards = i))
            extrudeZaxis(fence_4inch_board);        
    }

    move_board_up(spacing(spacers = 3, thin_boards = 0, thick_boards = 3))
    for (i=[0:5]) 
    {
        color(gdv(fence_4inch_board, "color"), 0.9)
        move_board_up(spacing(spacers = i*3 + 1, thin_boards = i*3 - i, thick_boards = i))
            extrudeZaxis(fence_4inch_board);

        color(gdv(fence_2inch_board, "color"), 0.9)
        move_board_up(spacing(spacers = i*3 + 2, thin_boards = i*3 - i, thick_boards = i + 1))
            extrudeZaxis(fence_2inch_board);

        color(gdv(fence_2inch_board, "color"), 0.9)
        move_board_up(spacing(spacers = i*3 + 3, thin_boards = oddInterval(i), thick_boards = i + 1))
            extrudeZaxis(fence_2inch_board);
    }

    //top boards
    move_board_up(spacing(spacers = 6 + (3*10), thin_boards = 2*5, thick_boards = 3 + 5))
    for(i=[0:3])
    {
        color(gdv(fence_2inch_board, "color"), 0.9)
        move_board_up(spacing2(spacers = i, thin_boards = i, thick_boards = 0))
        extrudeZaxis(fence_2inch_board);
    }

    //cap board
    move_board_up(gdv(fence_post, "z"))
    extrudeZaxis(fence_4inch_board_cap);

}

module extrudeYaxis(dic)
{
    linear_extrude(gdv(dic, "y"))
    square(size = [gdv(dic, "x"), gdv(dic, "z")], center = true);
}

module extrudeZaxis(dic)
{
    linear_extrude(gdv(dic, "z"))
    square(size = [gdv(dic, "x"), gdv(dic, "y")], center = true);
}

module move_board_up(height)
{
    // echo(height = convert_mm2in(height));
    translate([0,0,height]) 
    children();
}

module draw_post(post, trim) 
{
    union()
    {
        moveToCenter(post)
        applyColor(post, 0.9)
        applyExtrude(post)
        drawSquare(post);

        //draw trim
        applyColor(trim, 0.9)        
        applyExtrude(trim)
        union()
        {
            moveTo(trim, "loc 1")
            drawSquare(trim);

            moveTo(trim, "loc 2")
            drawSquare(trim);

            moveTo(trim, "loc 3")
            drawSquare(trim);

            moveTo(trim, "loc 4")
            drawSquare(trim);
        }        
    }

}

module draw_post_pair(post, trim) 
{
    moveTo(post, "loc east")
    draw_post(post, trim);

    moveTo(post, "loc west")
    draw_post(post, trim);

}

module draw_square(dic)
{
    square(size = [gdv(dic, "x"), gdv(dic, "y")], center = true);
}
