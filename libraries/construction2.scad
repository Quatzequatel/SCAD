/*
    function to make building easier to draft.
    Starting to create a library of modules to apply a change of actions using
    standard dictionary
*/
use <convert.scad>;
use <trigHelpers.scad>;
use <dictionary.scad>;

//constants
board_width = convert_in2mm(1.75);
board_depth = convert_in2mm(3.5);
block_width = convert_in2mm(8);
block_length = convert_in2mm(16);
block_height = convert_in2mm(8);

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

    // moveTo(locations, "p1")
    applyColor(vboard_2x4)
    // applyRotate(vboard_2x4) 
    // applyMove(vboard_2x4) 
    moveToOrigin(vboard_2x4)
    applyExtrude(vboard_2x4)
    drawSquare(vboard_2x4);
}

/*
    locations is a dictionary, 
    where label is element of vector[x,y,z]
    usage => moveTo(locations, "p1") childern();
*/
module moveTo(locations, label)
{
    translate(gdv(locations, label)) children();
}

module moveToOrigin(properties) 
{
    translate([gdv(properties, "x")/2, gdv(properties, "y")/2]) children();
}

module apply_X_Move(properties) 
{
    translate([gdv(properties, "x"), 0, 0]) children();
}

module apply_Y_Move(properties) 
{
    translate([0, gdv(properties, "y"), 0]) children();
}

module apply_Z_Move(properties) 
{
    translate([0, 0, gdv(properties, "z")]) children();
}

/*
    properties is standard object dictionary.
    template:
        object = 
        [ "verbose description",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];   
    usage =>  applyMove(object) applyRotate(object) applyExtrude(object) drawSquare(object);
*/
module applyMove(properties)
{
    translate(gdv(properties, "move")) children();
}

/*
    properties is standard object dictionary.
    template:
        object = 
        [ "verbose description",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];   
    usage =>  applyRotate(object) drawCube(object);
*/
module applyRotate(properties)
{
    rotate(gdv(properties, "rotate")) children();
}

/*
    properties is standard object dictionary.
    template:
        object = 
        [ "verbose description",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];   
    usage =>  applyColor(object) drawCube(object);
*/
module applyColor(properties, alpha  = 0.5)
{
    color(gdv(properties, "color"), alpha ) children();
}

/*
    properties is standard object dictionary.
    template:
        object = 
        [ "verbose description",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];   
    usage =>  applyExtrude(object) drawCube(object);
*/
module applyExtrude(properties)
{
    linear_extrude(gdv(properties, "z")) children();
}

/*
    draws a horizontal (x-axis) shelf,
    consisting of 2 x-axis boards of [length],
    and topped with plywood of [length, width, thickness]
*/
module draw_xShelf(length, width, thickness, include_cross_brace = true, boardcolor = "SaddleBrown" , shelfcolor = "Ivory")
{
    // board_width = convert_in2mm(1.75);
    // board_depth = convert_in2mm(3.5);

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

/*
    draws a horizontal (y-axis) shelf,
    consisting of 2 y-axis boards of [length],
    and topped with plywood of [length, width, thickness]
*/
module draw_yShelf(length, width, thickness, include_cross_brace = true, boardcolor = "SaddleBrown" , shelfcolor = "Ivory")
{
    //echo()
    // board_width = convert_in2mm(1.75);
    // board_depth = convert_in2mm(3.5);

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

/*
    draws a horizontal (x-axis) board of length.
*/
module draw_yboard(length, boardcolor = "SaddleBrown")
{
    color(boardcolor, 0.5)
    linear_extrude(board_depth)
    square(size=[board_width, length], center=false);    
}

/*
    draws a horizontal (x-axis) board of length.
*/
module draw_xboard(length, boardcolor = "SaddleBrown")
{
    color(boardcolor, 0.5)
    linear_extrude(board_depth)
    square(size=[ length, board_width], center=false);    
}

/*
    draws a vertical (z-axis) board of length.
*/
module draw_zboard(length, boardcolor = "SaddleBrown")
{
    color(boardcolor, 0.5)
    linear_extrude(length)
    square(size=[board_width, board_depth], center=false);    
}

/*
    draws a cube of [x,y,z] dimensions.
    properties is standard object dictionary.
    template:
        object = 
        [ "verbose description",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];   
    usage =>  applyColor(object) drawCube(object);
*/
module drawCube(properties)
{
    applyExtrude(properties)
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=false);    
}

/*
    draws a 2D square of [x,y,z] dimensions.
    properties is standard object dictionary.
    template:
        object = 
        [ "verbose description",
            ["x", convert_in2mm(1.75)],
            ["y", convert_in2mm(3.5)],
            ["z", convert_in2mm(58)],
            ["move", [100, 50, 0]],
            ["rotate", [ 0, 90, 0] ],
            ["color", "LightSlateGray"]
        ];   
    
    usage =>  moveToOrigin(object) applyExtrude(object) drawSquare(object);
*/
module drawSquare(properties)
{
	square(size=[gdv(properties, "x"), gdv(properties, "y")], center=true);
}