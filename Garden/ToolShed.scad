/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;

//height in back is 74,
//height in front is 91.


shedInteriorWidth = convert_in2mm(88.6);
shedInteriorLength = convert_in2mm(88.6);
BACK_SHELF_WIDTH = convert_in2mm(32);
OUTSIDE_SHELF_WIDTH = convert_in2mm(16);
SIDE_SHELF_WIDTH = convert_in2mm(24);
shelfLength = convert_in2mm(90.1 - 1.5);
SIDE_SHELF_LENGHTH = convert_in2mm(54.5);
// FULL_SHELF_THICKNESS = convert_in2mm(3.5 + 0.75);
PLYWOOD_THICKNESS = convert_in2mm(0.75);
SHELF_BEAM_WIDTH = convert_in2mm(1.75);
SHELF_BEAM_THICKNESS = convert_in2mm(3.5);
FULL_SHELF_THICKNESS = SHELF_BEAM_THICKNESS + PLYWOOD_THICKNESS;

shedExteriorLength = convert_in2mm(7 * 12 + 4.6 + 1.5);
shedExteriorWidth = convert_in2mm(7 * 12 + 4.6 + 1.5);

// echo(shedExteriorWidth = convert_mm2in(shedExteriorWidth), shedExteriorLength = convert_mm2in(shedExteriorLength));

BEAM_DEF =
[
    "2X4 definition",
    ["x", SHELF_BEAM_WIDTH],
    ["y", SHELF_BEAM_THICKNESS]
];

shed = 
[
    "Tool Shed", 
    ["x", shedExteriorLength],
    ["y", shedExteriorWidth],
    // ["z", convert_in2mm(7 * 12 + 6.5)],
    ["z", convert_in2mm(74)],
    ["wall thickness", convert_in2mm(0.75)],
    ["floor thickness", convert_in2mm(1.75)],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightBlue"]
];

shed_door = 
["Tool Shed Door", 
    ["x", convert_in2mm(0.85)],
    // // // Actual door cut
    // ["y", convert_in2mm(58.2)],
    // ["z", convert_in2mm(74.3)],
    // ["move", [gdv(shed, "x") - gdv(shed, "wall thickness")-1, gdv(shed, "y")/2 - convert_in2mm(58.2)/2, gdv(shed, "floor thickness")]],
    // // // end actual door
    //
    // start no door wall
    ["y", convert_in2mm(7 * 12 + 4.6 + 1.5)],
    ["z", convert_in2mm(90)],
    ["move", [gdv(shed, "x") - gdv(shed, "wall thickness")-1, 0 , gdv(shed, "floor thickness")]],
    //end no door wall.
    ["wall thickness", convert_in2mm(0.75)],
    ["floor thickness", convert_in2mm(1)],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

// side_Shelf_width = convert_in2mm(24);
bottom_shelf_support_origin_x = gdv(shed, "wall thickness") + BACK_SHELF_WIDTH + convert_in2mm(1.5);
bottom_shelf_support_origin_y = gdv(shed, "wall thickness");
bottom_shelf_support_origin_Z = gdv(shed, "floor thickness");
/*
    ****
    location information for shelf legs.
    ****
*/
// Use this format for nesting dictionaries.
side_shelf_legs_yx_locations =
[
    [
        "location", 
        [
            [bottom_shelf_support_origin_x, bottom_shelf_support_origin_y],
            [bottom_shelf_support_origin_x, bottom_shelf_support_origin_y + SIDE_SHELF_WIDTH - SHELF_BEAM_THICKNESS],
            [bottom_shelf_support_origin_x + SIDE_SHELF_LENGHTH - SHELF_BEAM_WIDTH, bottom_shelf_support_origin_y],
            [bottom_shelf_support_origin_x + SIDE_SHELF_LENGHTH - SHELF_BEAM_WIDTH, bottom_shelf_support_origin_y + SIDE_SHELF_WIDTH - SHELF_BEAM_THICKNESS]
        ]
    ]
];

shelf_vertical_locations = 
[
    bottom_shelf_support_origin_Z,
    bottom_shelf_support_origin_Z 
        + convert_in2mm(18.5) + FULL_SHELF_THICKNESS,
    bottom_shelf_support_origin_Z 
        + convert_in2mm(18.5) + FULL_SHELF_THICKNESS 
        + convert_in2mm(16) + FULL_SHELF_THICKNESS,
    bottom_shelf_support_origin_Z 
        + convert_in2mm(18.5) + FULL_SHELF_THICKNESS 
        + convert_in2mm(16) + FULL_SHELF_THICKNESS 
        + convert_in2mm(12) + FULL_SHELF_THICKNESS
];

shelf_beam_vertical_locations = 
[
    bottom_shelf_support_origin_Z 
        + convert_in2mm(18.5),
    bottom_shelf_support_origin_Z 
        + convert_in2mm(18.5) + FULL_SHELF_THICKNESS 
        + convert_in2mm(16),
    bottom_shelf_support_origin_Z 
        + convert_in2mm(18.5) + FULL_SHELF_THICKNESS 
        + convert_in2mm(16) + FULL_SHELF_THICKNESS 
        + convert_in2mm(12) 
];

shelf_beam_values = 
[
    "shelf beam values",
    [
        ["label", "vertical shelf support for bottom shelf"],
        ["x", SIDE_SHELF_LENGHTH],
        ["y", SIDE_SHELF_WIDTH],
        ["z", SHELF_BEAM_THICKNESS],
        ["move", [0, 0, shelf_vertical_locations[0]]],
        ["rotate", [ 0, 0, 0] ],
        ["color", "yellow"]         
    ]
];

bottom_shelf_support =
[
    "shelf_support",
        ["label", "vertical shelf support for bottom shelf"],
        ["x", convert_in2mm(1.75)],
        ["y", SHELF_BEAM_THICKNESS],
        ["z", convert_in2mm(18.5)],
        ["move", [0, 0, shelf_vertical_locations[0]]],
        ["rotate", [ 0, 0, 0] ],
        ["color", "yellow"]    
];


middle_shelf_support = 
[
    "shelf_support",
        ["label", "vertical shelf support for middle shelf"],
        ["x", convert_in2mm(1.75)],
        ["y", SHELF_BEAM_THICKNESS],
        ["z", convert_in2mm(16)],
        ["move", [0, 0, shelf_vertical_locations[1]]],       
        ["rotate", [ 0, 0, 0] ],
        ["color", "LightSlateGray"]    
];

top_shelf_support = 
[
    "shelf_support",
        ["label", "vertical shelf support for top shelf"],    
        ["x", convert_in2mm(1.75)],
        ["y", SHELF_BEAM_THICKNESS],
        ["z", convert_in2mm(12)],
        ["move", [0, 0, shelf_vertical_locations[2]]],        
        ["rotate", [ 0, 0, 0] ],
        ["color", "LightSlateGray"]    
];

side_shelf_vertical_locations = 
[
            bottom_shelf_support_origin_Z + gdv(bottom_shelf_support, "z") + SHELF_BEAM_THICKNESS,
            gdv(middle_shelf_support, "move").z + gdv(middle_shelf_support, "z"),
            gdv(top_shelf_support, "move").z + gdv(top_shelf_support, "z")
];

side_shelf_sheet = 
[
    "defining the side shelf plywood",
        ["label", "shelf top"],    
        ["x", SIDE_SHELF_LENGHTH],
        ["y", SIDE_SHELF_WIDTH ],
        ["z", PLYWOOD_THICKNESS],
        ["move", [0, 0, 0]],        
        ["rotate", [ 0, 0, 0] ],
        ["color", "LightSlateGray"]    
];

vboard_2x4 = 
    [ "vertical board 2x4",
        ["x", convert_in2mm(1.75)],
        ["y", SHELF_BEAM_THICKNESS],
        ["z", convert_in2mm(58)],
        ["move", [0, 0, 0]],
        ["rotate", [ 0, 0, 0] ],
        ["color", "LightSlateGray"]
    ];

hboard_2x4 = 
    [ "horizontal board 2x4",
        ["x", convert_in2mm(1.75)],
        ["y", shelfLength],
        ["z", SHELF_BEAM_THICKNESS],
        ["rotate", [ 0, 0, 0] ],
        ["move", [0, 0, 0]],
        ["color", "SaddleBrown"]
    ];

hboard_2x4_side = 
    [ "side horizontal board 2x4",
        ["x", convert_in2mm(1.75)],
        ["y", SIDE_SHELF_LENGHTH],
        ["z", SHELF_BEAM_THICKNESS],
        ["rotate", [ 0, 0, 0] ],
        ["move", [0, 0, 0]],
        ["color", "Goldenrod"]
    ];    

hboard_2x4_brace = 
    [ "horizontal brace board 2x4",
        ["x", convert_in2mm(1.75)],
        ["y", BACK_SHELF_WIDTH - SHELF_BEAM_THICKNESS],
        ["z", SHELF_BEAM_THICKNESS],
        ["rotate", [ 0, 0, -90] ],
        ["move", [convert_in2mm(-2.5),  convert_in2mm(0.75), 0]],
        ["color", "Goldenrod"]
    ];    

storage_bin = 
    [ "storage_bin",
        ["x", convert_in2mm(16)],
        ["y", convert_in2mm(22)],
        ["z", convert_in2mm(11)],
        ["rotate", [ 0, 0, -90] ],
        ["move", [0, 0, 0]],
        ["color", "Gainsboro"]
    ];      



shelf1 = 
    [
        "shelf",
        ["x", BACK_SHELF_WIDTH],
        ["y", shelfLength],
        ["z", convert_in2mm(0.75)],
        ["rotate", [ 0, 0, 0] ],
        ["move", [0, 0, 0]],
        ["color", "Ivory"]        
    ];

shelf2 = 
    [
        "shelf",
        ["x", SIDE_SHELF_LENGHTH],
        ["y", OUTSIDE_SHELF_WIDTH],
        ["z", convert_in2mm(0.75)],
        ["rotate", [ 0, 0, 0] ],
        ["move", [0, 0, 0]],
        ["color", "Ivory"]        
    ];

    //points
    x1 = gdv(shed, "wall thickness");
    x2 = x1 + BACK_SHELF_WIDTH - gdv(vboard_2x4, "x");
    x3 = x1 + gdv(vboard_2x4, "x")/2;
    x4 = x2 + gdv(vboard_2x4, "x");
    x5 = x4 - gdv(vboard_2x4, "x")/2;
    x10 = x1 + gdv(vboard_2x4, "x");

    y1 = gdv(shed, "wall thickness");
    y2 = gdv(hboard_2x4, "y") - (convert_in2mm(2) + gdv(shed, "wall thickness"));
    y3 =  gdv(hboard_2x4, "y") - gdv(hboard_2x4, "x");
    y4 =  y1 + gdv(hboard_2x4, "y")/2;
    y5 =  y1 + gdv(vboard_2x4, "y");

    zTopBack = convert_in2mm(74);
    zTopFront = convert_in2mm(91);

    z1 = gdv(shed, "floor thickness");
    z2 = z1 + BACK_SHELF_WIDTH;
    z3 = z2 + gdv(hboard_2x4, "z");
    z4 = z2 + BACK_SHELF_WIDTH;
    z5 = z4 + gdv(hboard_2x4, "z");
    // z6 = z4 + BACK_SHELF_WIDTH;
    z6 = z1 + zTopBack + convert_in2mm( - 10);
    z7 = z6 + gdv(hboard_2x4, "z");    

    zShelf1 = z1 + convert_in2mm(18);
    zShelfT1 = zShelf1 + SHELF_BEAM_THICKNESS;
    zShelf2 = zShelf1 + FULL_SHELF_THICKNESS + convert_in2mm(16);
    zShelfT2 = zShelf2 + SHELF_BEAM_THICKNESS;
    zShelf3 = zShelf2 +FULL_SHELF_THICKNESS + convert_in2mm(12);
    zShelfT3 = zShelf3 + SHELF_BEAM_THICKNESS;
    // zShelf4 = zShelf3 +FULL_SHELF_THICKNESS + convert_in2mm(12);

    //Draw ? objects
    DRAW_SHELVES = true;
    DRAW_BACK_SHELVE = true;
    DRAW_SIDE_SHELVE = false;
    DRAW_OUTSIDE_SIDE_SHELVE = false;
    DRAW_TOOL_SHED = true;

build();    

module build() 
{
    if(DRAW_TOOL_SHED) draw_shed(shed, shed_door);
    if (DRAW_SHELVES) 
    {
        draw_shelving() ;  
        draw_side_segmented_shelf_support();
        // draw_back_segmented_shelf_support();
    }    

    // properties_echo(concat(BEAM_DEF, [["z", 100]]));
    // draw_shelf_beams(shelf_beam_values, vector = [0,0,0]);
}

module draw_side_segmented_shelf_support()
{
    //lists of support boards.
    
    support = [bottom_shelf_support, middle_shelf_support, top_shelf_support];

    for ( i = [0:2] ) 
    {
        // echo(side_shelf_vertical_locations);
        // echo(i =i, gdv=side_shelf_vertical_locations[i]);
        let(merge = concat(support[i], side_shelf_legs_yx_locations))
        {
            draw_segmented_shelf_posts(merge);
            draw_plywood_sheet(side_shelf_sheet, [bottom_shelf_support_origin_x, gdv(shed, "wall thickness"), shelf_vertical_locations[i+1] - PLYWOOD_THICKNESS]);
        }

    }
}

module draw_plywood_sheet(values, vector)
{
    translate(vector)
    drawCube(values);
}


module draw_shelf_beams(values, vector = [0,0,0])
{
    properties_echo(values);
    if(gdv(values, "x") < gdv(values, "y"))
    {
        //x is length of shelf
        translate([0, 0, 0])
        rotate([0, 0, 0])
        linear_extrude(SHELF_BEAM_THICKNESS)
        square(size = [SHELF_BEAM_WIDTH, gdv(values, "x")], center = true);

    }
    else
    {
        //y is length of shelf
        translate([0, 0, 0])
        rotate([0, 0, 0])
        linear_extrude(gdv(values, "z"))
        square(size = [gdv(values, "y"), gdv(values, "x")], center = true);        
    }
    
}

module draw_back_segmented_shelf_support()
{
    //lists of support boards.
    for (i=[bottom_shelf_support, middle_shelf_support, top_shelf_support]) 
    {
        // properties_echo(i);
        // draw_segmented_shelf_posts(i);
    }
    
}

module draw_segmented_shelf_posts(values) 
{
    // i=0 is lable.
    for (i=[0:3]) 
    {
        echo(i=i, gda = gdv(values, "location")[i]);
        //post 1 (i)
        translate(gdv(values, "location")[i])
        draw_vertical_2x4(values);
    }
   
}


module draw_shed(shed, door)
{
    //information mark.
    translate([x1,0,convert_in2mm(74)])
    rotate([-90,0,0])
    color("Red",0.5)
    linear_extrude(gdv(shed, "y"))
    circle(r=5);

    spacer = 100;
    Add_Label(convert_mm2in( shedInteriorWidth), [shedInteriorWidth/2, -spacer]);
    Add_Label(convert_mm2in( gdv(shed, "x")), [gdv(shed, "x")/2, -spacer * 2]);
    Add_Label(convert_mm2in( shedInteriorWidth), [shedInteriorWidth + spacer , gdv(shed, "y")/2], [0,0,90]);
    Add_Label(convert_mm2in( gdv(shed, "y")), [gdv(shed, "y") + spacer * 2, gdv(shed, "y")/2], [0,0,90]);

    Add_Label(text = convert_mm2in( gdv(vboard_2x4, "z")), location = [ gdv(shed, "x") + 100, 70, gdv(vboard_2x4, "z")/2], rotation = [0, 90, 0]);

    union()
    {

        difference()
        {
            color(gdv(shed, "color"), 0.5)
            linear_extrude(gdv(shed, "z"))
            square(size=[gdv(shed, "x"), gdv(shed, "y")], center=false);

            translate([gdv(shed, "wall thickness"), gdv(shed, "wall thickness"), gdv(shed, "floor thickness")])
            linear_extrude(gdv(shed, "z"))
            square(size=[gdv(shed, "x") - 2 * gdv(shed, "wall thickness"), gdv(shed, "y") - 2 * gdv(shed, "wall thickness")], center=false);

            //door
            translate(gdv(door, "move"))
            linear_extrude(gdv(door, "z"))
            square(size=[gdv(door, "x"), gdv(door, "y")], center=false);
        }
    }

    // draw_storage_bins();
}

module Add_Label ( text, location, rotation)
{

    color("black", 0.5)
    translate(location)
    if(rotation != undef )
        rotate(rotation)
        text(str("<- ", text, " inches ->"), font = "Liberation Sans:style=Bold Italic", size = 72, halign = "center", valign = "center");
    else
        text(str("<- ", text, " inches ->"), font = "Liberation Sans:style=Bold Italic", size = 72, halign = "center", valign = "center");
}


module draw_shelving() 
{

    if(DRAW_BACK_SHELVE) 
    {
        draw_shelf_posts();
        draw_shelf_support();
        draw_shelf_braces();
        draw_shelfs();
    }

    if(DRAW_SIDE_SHELVE) 
    {
        draw_shelf_posts2();
        draw_shelf_support2();
    }

    if(DRAW_OUTSIDE_SIDE_SHELVE) 
    {
        draw_external_shelve();
    }
    
}

module draw_shelf_posts() 
{
    // color("red", 0.5)
    Add_Label(text = convert_mm2in( gdv(vboard_2x4, "z")), location = [ gdv(shelf1, "x") + 100, gdv(shelf1, "y")-25, gdv(vboard_2x4, "z")/2], rotation = [0, 90, 0]);    
    //post 1
    translate([x1, y1, z1])
    draw_vertical_2x4(vboard_2x4);

    //post 2
    translate([x4, y1, z1])
    draw_vertical_2x4(vboard_2x4);

    //post 3
    translate([x1, y2, z1])
    draw_vertical_2x4(vboard_2x4);

    //post 4  
    translate([x4, y2, z1]) 
    draw_vertical_2x4(vboard_2x4);    
}

module draw_external_shelve()
{
    // postThickness = convert_in2mm(1.75);
    postFloor = convert_in2mm(-12);
    tallPost = convert_in2mm(84);
    shortPost = convert_in2mm(79);
    shelfHeightTall = convert_in2mm(18) + convert_in2mm(4.25);
    shelfHeightMedium = convert_in2mm(16) + convert_in2mm(4.25);
    shelfHeightShort = convert_in2mm(14) + convert_in2mm(4.25);

    yorigin = shedExteriorWidth;
    
    board_width = convert_in2mm(1.75);
    board_depth = SHELF_BEAM_THICKNESS;
    half_width = board_width/2;

    echo(RoffLength = sqrt(2 * 24^2));

    echo(TallPost = convert_mm2in(tallPost));
    echo(ShortPost = convert_mm2in(shortPost));

    echo(ExteneralShelf1 = convert_mm2in(postFloor));
    echo(ExteneralShelf2 = convert_mm2in(shelfHeightShort));
    echo(ExteneralShelf3 = convert_mm2in(shelfHeightMedium));
    echo(ExteneralShelf4 = convert_mm2in(shelfHeightTall));
    

    //TODO
    locations = 
    [
        "locations",
        ["p1", [ 0, yorigin, postFloor ] ],
        ["p2", [ 0, yorigin + OUTSIDE_SHELF_WIDTH - board_depth, postFloor ] ],
        ["p3", [ shedInteriorLength, yorigin, postFloor ] ],
        ["p4", [ shedInteriorLength, yorigin + OUTSIDE_SHELF_WIDTH - board_depth, postFloor ] ],
        ["r1", [ 0, yorigin + convert_in2mm(0), convert_in2mm(74) ] ],
        ["s0", [ half_width, yorigin , postFloor ] ],
        ["s1", [ half_width, yorigin , postFloor + shelfHeightTall ] ],
        ["s2", [ half_width, yorigin , postFloor + shelfHeightTall + shelfHeightMedium ] ],
        ["s3", [ half_width, yorigin , postFloor + shelfHeightTall + shelfHeightMedium + shelfHeightShort ] ]
    ];

    shelves =
    [
        "shelf heights",
        ["s1", zShelf1],
        ["s2", zShelf2],
        ["s3", zShelf3]
    ];

    outsidePost1 = 
    [ "outside post 1",
        ["x", convert_in2mm(1.75)],
        ["y", SHELF_BEAM_THICKNESS],
        ["z", convert_in2mm(84)],
        ["move", [0, 0, 0] ],
        ["rotate", [ 0, 0, 0] ],
        ["color", "LightSlateGray"]
    ];

    outsidePost2 = 
    [ "outside post 2",
        ["x", convert_in2mm(1.75)],
        ["y", SHELF_BEAM_THICKNESS],
        ["z", convert_in2mm(68)],
        ["move", [0, 0, 0]],
        ["rotate", [ 0, 0, 0] ],
        ["color", "LightSlateGray"]
    ];

    roof = 
    [
        "cleat properties", 
        ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
        ["parallelogram thickness", convert_in2mm(20)],
        ["angle", 135],
        ["extrude height", shedExteriorLength],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0, 0, 0]],
        ["color", "LightGrey"]
    ];

    moveTo(locations, "p1") draw_zboard(tallPost);
    moveTo(locations, "p2") draw_zboard(shortPost);
    moveTo(locations, "p3") draw_zboard(tallPost);
    moveTo(locations, "p4") draw_zboard(shortPost);
    
    moveTo(locations, "r1") 
    rotate([70, 0, 0]) 
    draw_parallelogram(roof);

    moveTo(locations, "s0") draw_xShelf(shedExteriorLength - convert_in2mm(1.75), OUTSIDE_SHELF_WIDTH, convert_in2mm(0.75));
    moveTo(locations, "s1") draw_xShelf(shedExteriorLength - convert_in2mm(1.75), OUTSIDE_SHELF_WIDTH, convert_in2mm(0.75));
    moveTo(locations, "s2") draw_xShelf(shedExteriorLength - convert_in2mm(1.75), OUTSIDE_SHELF_WIDTH, convert_in2mm(0.75));
    moveTo(locations, "s3") draw_xShelf(shedExteriorLength - convert_in2mm(1.75), OUTSIDE_SHELF_WIDTH, convert_in2mm(0.75));

    mmBoardLength = shedExteriorLength - convert_in2mm(1.75);

    echo( mm = mmBoardLength, board = convert_mm2in(mmBoardLength));
    echo( inches = mmBoardLength/mmPerInch);
}

module moveTo(location, lable)
{
    // echo(value = gdv(location, lable));
    translate(gdv(location, lable)) children();
}

module draw_xShelf(length, width, thickness, include_cross_brace = true, boardcolor = "SaddleBrown" , shelfcolor = "Ivory")
{
    board_width = convert_in2mm(1.75);
    board_depth = SHELF_BEAM_THICKNESS;

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
    board_depth = SHELF_BEAM_THICKNESS;

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
    board_depth = SHELF_BEAM_THICKNESS;

    color(boardcolor, 0.5)
    linear_extrude(board_depth)
    square(size=[board_width, length], center=false);    
}

module draw_xboard(length, boardcolor = "SaddleBrown")
{
    board_width = convert_in2mm(1.75);
    board_depth = SHELF_BEAM_THICKNESS;

    echo(board_length_x = convert_mm2in(length));
    
    color(boardcolor, 0.5)
    linear_extrude(board_depth)
    square(size=[ length, board_width], center=false);    
}

module draw_zboard(length, boardcolor = "SaddleBrown")
{
    board_width = convert_in2mm(1.75);
    board_depth = SHELF_BEAM_THICKNESS;
    
    color(boardcolor, 0.5)
    linear_extrude(length)
    square(size=[board_width, board_depth], center=false);    
}

module draw_shelf_posts2() 
{
    //TODO
    x20 = x1 + BACK_SHELF_WIDTH +  gdv(vboard_2x4, "x");
    x21 = x20 + convert_in2mm(48) + convert_in2mm(3);

    y20 = y1 + gdv(vboard_2x4, "x");
    y22 = y1 + gdv(vboard_2x4, "x")/2;
    y21 = y20 + OUTSIDE_SHELF_WIDTH;

    //post 1
    translate([x20, y20, z1])
    draw_vertical_2x4_2(vboard_2x4);

    //post 2
    translate([x21 , y20, z1])
    #draw_vertical_2x4_2(vboard_2x4);

    //post 3
    translate([x20, y21, z1])
    draw_vertical_2x4_2(vboard_2x4);

    //post 4  
    translate([x21, y21, z1])
    #draw_vertical_2x4_2(vboard_2x4);    

     //shelf 1
    color(gdv(shed, "color"), 0.25)
    translate ([x20 , y22, zShelfT1])
    linear_extrude(gdv(shelf2, "z"))
    square(size=[gdv(shelf2, "x"), gdv(shelf2, "y")], center=false);

    //shelf 2
    color(gdv(shed, "color"), 0.25)
    translate ([x20 , y22, zShelfT2])
    linear_extrude(gdv(shelf2, "z"))
    square(size=[gdv(shelf2, "x"), gdv(shelf2, "y")], center=false);

    //shelf 3
    color(gdv(shed, "color"), 0.25)
    translate ([x20 , y22, zShelfT3])
    linear_extrude(gdv(shelf2, "z"))
    square(size=[gdv(shelf2, "x"), gdv(shelf2, "y")], center=false);
}

module draw_shelf_support2()
{
    //TODO
    x20 = x1 + BACK_SHELF_WIDTH;// +  gdv(vboard_2x4, "x");
    x21 = x20 + SIDE_SHELF_LENGHTH;

    x200 = x2 + gdv(hboard_2x4_side, "y") + SHELF_BEAM_THICKNESS ;//+ BACK_SHELF_WIDTH + gdv(vboard_2x4, "x");

    y20 = y1 + gdv(vboard_2x4, "x");
    y21 = y20 + OUTSIDE_SHELF_WIDTH - convert_in2mm(1.5) ;

    Add_Label(convert_mm2in( gdv(hboard_2x4_side, "y")), [x200 - gdv(hboard_2x4_side, "y")/2 ,y21 + 100, 26]);
    echo(shelf1 = convert_mm2in(zShelf1));
    echo(shelf2 = convert_mm2in(zShelf2));
    echo(shelf3 = convert_mm2in(zShelf3));

    //shelf support 1.1
    translate([x200, y1 + convert_in2mm(0), zShelf1])
    rotate([0, 0, 90])
    draw_vertical_2x4(hboard_2x4_side);

    //shelf support 1.2
    translate([x200, y21, zShelf1])
    rotate([0, 0, 90])
    draw_vertical_2x4(hboard_2x4_side);    

    //shelf support 2.1
    translate([x200, y1 + convert_in2mm(0), zShelf2])
    rotate([0, 0, 90])
    draw_vertical_2x4(hboard_2x4_side);

    //shelf support 2.2
    translate([x200, y21, zShelf2])
    rotate([0, 0, 90])
    draw_vertical_2x4(hboard_2x4_side); 

    //shelf support 3.1
    translate([x200, y1 + convert_in2mm(0), zShelf3])
    rotate([0, 0, 90])
    draw_vertical_2x4(hboard_2x4_side);

    //shelf support 3.2
    translate([x200, y21, zShelf3])
    rotate([0, 0, 90])
    draw_vertical_2x4(hboard_2x4_side); 
}

module draw_shelf_support()
{
    Add_Label(convert_mm2in( gdv(hboard_2x4, "y")), [gdv(shelf1, "x") , gdv(hboard_2x4, "y")/2, 26], [0,0,90]);
    //shelf support 1.1
    translate([x3, y1, zShelf1])
    draw_vertical_2x4(hboard_2x4);

    //shelf support 1.2
    translate([x5, y1, zShelf1])
    draw_vertical_2x4(hboard_2x4);

    //shelf support 2.1
    translate([x3 , y1, zShelf2])
    draw_vertical_2x4(hboard_2x4);

    //shelf support 2.2
    translate([x5 , y1, zShelf2])
    draw_vertical_2x4(hboard_2x4);

    //shelf support 3.1
    translate([x3 , y1, zShelf3])
    draw_vertical_2x4(hboard_2x4);

    //shelf support 3.2
    translate([x5 , y1, zShelf3])
    draw_vertical_2x4(hboard_2x4);

    // //shelf support 4.1
    // translate([x3 , y1, zShelf4])
    // draw_vertical_2x4(hboard_2x4);

    // //shelf support 4.2
    // translate([x5 , y1, zShelf4])
    // draw_vertical_2x4(hboard_2x4);
}

module draw_shelf_braces()
{
    //shelf brace 1.1
    translate([x10, 0, zShelf1])
    draw_vertical_2x4(hboard_2x4_brace);

    //shelf brace 1.2
    translate([x10, y4, zShelf1])
    #draw_vertical_2x4(hboard_2x4_brace);

    //shelf brace 1.3
    translate([x10, y3, zShelf1])
    draw_vertical_2x4(hboard_2x4_brace);

    //shelf brace 2.1
    translate([x10, 0, zShelf2])
    draw_vertical_2x4(hboard_2x4_brace);

    //shelf brace 2.2
    translate([x10, y4, zShelf2])
    draw_vertical_2x4(hboard_2x4_brace);

    //shelf brace 2.3
    translate([x10, y3, zShelf2])
    draw_vertical_2x4(hboard_2x4_brace);

    //shelf brace 3.1
    translate([x10, 0, zShelf3])
    draw_vertical_2x4(hboard_2x4_brace);

    //shelf brace 3.2
    translate([x10, y4, zShelf3])
    draw_vertical_2x4(hboard_2x4_brace);

    //shelf brace 3.3
    translate([x10, y3, zShelf3])
    draw_vertical_2x4(hboard_2x4_brace);
}

module draw_shelfs()
{
    //shelf 1
    color(gdv(shed, "color"), 0.25)
    translate ([x3 , y1, zShelfT1])
    linear_extrude(gdv(shelf1, "z"))
    square(size=[gdv(shelf1, "x"), gdv(shelf1, "y")], center=false);

    //shelf 2
    color(gdv(shed, "color"), 0.25)
    translate ([x3 , y1, zShelfT2])
    linear_extrude(gdv(shelf1, "z"))
    square(size=[gdv(shelf1, "x"), gdv(shelf1, "y")], center=false);

    //shelf 3
    color(gdv(shed, "color"), 0.25)
    translate ([x3 , y1, zShelfT3])
    linear_extrude(gdv(shelf1, "z"))
    square(size=[gdv(shelf1, "x"), gdv(shelf1, "y")], center=false); 
}

module draw_storage_bins()
{
    binWidthAndSpace = gdv(storage_bin, "y") + 10;
    //TODO

    //first shelf
    translate([x10, y5, zShelf1 + FULL_SHELF_THICKNESS])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    //Second shelf row1
    translate([x10, y5, zShelf2 + FULL_SHELF_THICKNESS])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    translate([x10, y5 + binWidthAndSpace, zShelf2 + FULL_SHELF_THICKNESS])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    translate([x10, y5 + 2 * binWidthAndSpace, zShelf2 + FULL_SHELF_THICKNESS])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    translate([x10, y5 + 3 * binWidthAndSpace + gdv(storage_bin, "x") + 10, zShelf2 + FULL_SHELF_THICKNESS])
    rotate([0, 0, 0])
    draw_vertical_2x4(storage_bin);    

    //Second shelf row2
    translate([x10 + gdv(storage_bin, "x") + 25, y5, zShelf2 + FULL_SHELF_THICKNESS])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    translate([x10 + gdv(storage_bin, "x") + 25, y5 + binWidthAndSpace, zShelf2 + FULL_SHELF_THICKNESS])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    translate([x10 + gdv(storage_bin, "x") + 25, y5 + 2 * binWidthAndSpace, zShelf2 + FULL_SHELF_THICKNESS])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);
}

module draw_vertical_2x4_2(board) 
{
    rotate([0, 0, -90])
    draw_vertical_2x4(board);
}

module draw_vertical_2x4(board) 
{
    // properties_echo(board);
    if(gdv(board, "z") > 89)
    {
        // echo(board_length_z = convert_mm2in(gdv(board, "z")));
        // properties_echo(board);
    }
    else
    {
        // echo(board_length_y = convert_mm2in(gdv(board, "y")));
        // properties_echo(board);
    }
    
    color(gdv(board, "color"), 0.5)
    rotate(gdv(board, "rotate"))
    translate(gdv(board, "move"))
    linear_extrude(gdv(board, "z"))
    square(size=[gdv(board, "x"), gdv(board, "y")], center=false);
}