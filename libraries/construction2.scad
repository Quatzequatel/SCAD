/*
    
*/
use <convert.scad>;
use <trigHelpers.scad>;
use <dictionary.scad>;

build();

module build(args) 
{
    Thing();
}

module Thing()
{
    vboard_2x4 = 
    [ "vertical board 2x4",
        ["x", convert_in2mm(1.75)],
        ["y", convert_in2mm(3.5)],
        ["z", convert_in2mm(58)],
        ["move", [100, 50, 0]],
        ["rotate", [ 0, 90, 0] ],
        ["color", "LightSlateGray"]
    ];

    locations = 
    [
        "locations",
        ["p1", [ 100, 200, 10 ] ]
    ];

    // applyColor(vboard_2x4)
    // applyRotate(vboard_2x4) 
    // applyMove(vboard_2x4) 
    moveTo(locations,"p1")
    drawCube(vboard_2x4);


}

module moveTo(location, lable)
{
    translate(gdv(location, lable)) children();
}

module applyMove(properties)
{
    translate(gdv(properties, "move")) children();
}

module applyRotate(properties)
{
    rotate(gdv(properties, "rotate")) children();
}

module applyColor(properties)
{
    color(gdv(properties, "color"), 0.5) children();
}

module drawCube(properties)
{
    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=false);    
}

module draw_xShelf(length, width, thickness, include_cross_brace = true, boardcolor = "SaddleBrown" , shelfcolor = "Ivory")
{
    board_width = convert_in2mm(1.75);
    board_depth = convert_in2mm(3.5);

    //cross brace
    if(include_cross_brace == true)
    {
        translate([0, board_width, 0])
        draw_yboard(width- (2 * board_width));
        
        translate([length/2, board_width, 0])
        draw_yboard(width- (2 * board_width));

        translate([length - board_width, board_width, 0])
        draw_yboard(width- (2 * board_width));
    }

    //braces
    draw_xboard(length, boardcolor);

    translate([0, width - convert_in2mm(1.75)])
    draw_xboard(length, boardcolor);

    color(shelfcolor, 0.5)
    translate([0, 0, board_depth])
    linear_extrude(thickness)
    square(size=[length, width], center=false);
}

module draw_yShelf(length, width, thickness, include_cross_brace = true, boardcolor = "SaddleBrown" , shelfcolor = "Ivory")
{
    //echo()
    board_width = convert_in2mm(1.75);
    board_depth = convert_in2mm(3.5);

    //cross brace
    if(include_cross_brace == true)
    {
        translate([board_width, 0, 0])
        draw_xboard(width- (2 * board_width));
        
        translate([board_width, length/2, 0])
        draw_xboard(width- (2 * board_width));

        translate([board_width, length - board_width, 0])
        draw_xboard(width- (2 * board_width));
    }

    //braces
    draw_yboard(length, boardcolor);

    translate([width - board_width, 0])
    draw_yboard(length, boardcolor);

    color(shelfcolor, 0.5)
    translate([0, 0, board_depth])
    linear_extrude(thickness)
    square(size=[width, length], center=false);
}

module draw_yboard(length, boardcolor = "SaddleBrown")
{
    board_width = convert_in2mm(1.75);
    board_depth = convert_in2mm(3.5);

    color(boardcolor, 0.5)
    linear_extrude(board_depth)
    square(size=[board_width, length], center=false);    
}

module draw_xboard(length, boardcolor = "SaddleBrown")
{
    board_width = convert_in2mm(1.75);
    board_depth = convert_in2mm(3.5);
    
    color(boardcolor, 0.5)
    linear_extrude(board_depth)
    square(size=[ length, board_width], center=false);    
}

module draw_zboard(length, boardcolor = "SaddleBrown")
{
    board_width = convert_in2mm(1.75);
    board_depth = convert_in2mm(3.5);
    
    color(boardcolor, 0.5)
    linear_extrude(length)
    square(size=[board_width, board_depth], center=false);    
}