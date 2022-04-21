/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

//height in back is 74,
//height in front is 91.
shelfWidth = convert_in2mm(32);
shelfWidth2 = convert_in2mm(16);
shelfLength = convert_in2mm(90.1 - 1.5);
shelfThickness = convert_in2mm(3.5 + 0.75);

shed = 
["Tool Shed", 
    ["x", convert_in2mm(7 * 12 + 4.6 + 1.5)],
    ["y", convert_in2mm(7 * 12 + 4.6 + 1.5)],
    // ["z", convert_in2mm(7 * 12 + 6.5)],
    ["z", convert_in2mm(74)],
    ["wall thickness", convert_in2mm(0.75)],
    ["floor thickness", convert_in2mm(1)],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightBlue"]
];

shed_door = 
["Tool Shed Door", 
    ["x", convert_in2mm(0.85)],
    // ["y", convert_in2mm(58.2)],
    // ["z", convert_in2mm(74.3)],
    ["y", convert_in2mm(7 * 12 + 4.6 + 1.5)],
    ["z", convert_in2mm(90)],
    ["wall thickness", convert_in2mm(0.75)],
    ["floor thickness", convert_in2mm(1)],
    // ["move", [gdv(shed, "x") - gdv(shed, "wall thickness")-1, gdv(shed, "y")/2 - convert_in2mm(58.2)/2, gdv(shed, "floor thickness")]],
    ["move", [gdv(shed, "x") - gdv(shed, "wall thickness")-1, 0 , gdv(shed, "floor thickness")]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

vboard_2x4 = 
    [ "vertical board 2x4",
        ["x", convert_in2mm(1.75)],
        ["y", convert_in2mm(3.5)],
        ["z", convert_in2mm(58)],
        ["move", [0, 0, 0]],
        ["rotate", [ 0, 0, 0] ],
        ["color", "SaddleBrown"]
    ];

hboard_2x4 = 
    [ "horizontal board 2x4",
        ["x", convert_in2mm(1.75)],
        ["y", shelfLength],
        ["z", convert_in2mm(3.5)],
        ["rotate", [ 0, 0, 0] ],
        ["move", [0, 0, 0]],
        ["color", "SaddleBrown"]
    ];

hboard_2x4_brace = 
    [ "horizontal brace board 2x4",
        ["x", convert_in2mm(1.75)],
        ["y", shelfWidth - convert_in2mm(3.5)],
        ["z", convert_in2mm(3.5)],
        ["rotate", [ 0, 0, -90] ],
        ["move", [convert_in2mm(-2.5),  convert_in2mm(0.75), 0]],
        ["color", "SaddleBrown"]
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
        ["x", shelfWidth],
        ["y", shelfLength],
        ["z", convert_in2mm(0.75)],
        ["rotate", [ 0, 0, 0] ],
        ["move", [0, 0, 0]],
        ["color", "Ivory"]        
    ];

    //points
    x1 = gdv(shed, "wall thickness");
    x2 = x1 + shelfWidth - gdv(vboard_2x4, "x");
    x3 = x1 + gdv(vboard_2x4, "x")/2;
    x4 = x2 + gdv(vboard_2x4, "x");
    x5 = x4 - gdv(vboard_2x4, "x")/2;
    x10 = x1 + gdv(vboard_2x4, "x");

    y1 = gdv(shed, "wall thickness");
    y2 = gdv(hboard_2x4, "y") - (convert_in2mm(2) + gdv(shed, "wall thickness"));
    y3 =  gdv(hboard_2x4, "y") - gdv(hboard_2x4, "x");
    y4 =  y1 + gdv(hboard_2x4, "y")/2;

    zTopBack = convert_in2mm(74);
    zTopFront = convert_in2mm(91);

    z1 = gdv(shed, "floor thickness");
    z2 = z1 + shelfWidth;
    z3 = z2 + gdv(hboard_2x4, "z");
    z4 = z2 + shelfWidth;
    z5 = z4 + gdv(hboard_2x4, "z");
    // z6 = z4 + shelfWidth;
    z6 = z1 + zTopBack + convert_in2mm( - 10);
    z7 = z6 + gdv(hboard_2x4, "z");    

    zShelf1 = z1 + convert_in2mm(18);
    zShelfT1 = zShelf1 + convert_in2mm(3.5);
    zShelf2 = zShelf1 + shelfThickness + convert_in2mm(16);
    zShelfT2 = zShelf2 + convert_in2mm(3.5);
    zShelf3 = zShelf2 +shelfThickness + convert_in2mm(12);
    zShelfT3 = zShelf3 + convert_in2mm(3.5);
    // zShelf4 = zShelf3 +shelfThickness + convert_in2mm(12);

build();    

module build() 
{
    draw_shed(shed, shed_door);
    draw_back_shelf() ;  
}


module draw_shed(shed, door)
{
    translate([x1,0,convert_in2mm(74)])
    rotate([-90,0,0])
    color("Red",0.5)
    linear_extrude(gdv(shed, "y"))
    circle(r=5);

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

    draw_storage_bins();
}

module draw_back_shelf() 
{

    draw_shelf_posts();
    draw_shelf_support();
    draw_shelf_braces();
    draw_shelfs();

    draw_shelf_posts2();
}

module draw_shelf_posts() 
{

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

module draw_shelf_posts2() 
{

    x20 = x1 + shelfWidth +  gdv(vboard_2x4, "x");
    x21 = x20 + convert_in2mm(48);

    y20 = y1 + gdv(vboard_2x4, "x");
    y21 = y20 + shelfWidth2;

    //post 1
    translate([x20, y20, z1])
    draw_vertical_2x4_2(vboard_2x4);

    //post 2
    translate([x21, y20, z1])
    draw_vertical_2x4_2(vboard_2x4);

    //post 3
    translate([x20, y21, z1])
    draw_vertical_2x4_2(vboard_2x4);

    //post 4  
    translate([x21, y21, z1])
    draw_vertical_2x4_2(vboard_2x4);    
}

module draw_shelf_support()
{
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

    //first shelf
    translate([x10, y4, zShelf1 + shelfThickness])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    //Second shelf row1
    translate([x10, y4, zShelf2 + shelfThickness])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    translate([x10, y4 + binWidthAndSpace, zShelf2 + shelfThickness])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    translate([x10, y4 + 2 * binWidthAndSpace, zShelf2 + shelfThickness])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    translate([x10, y4 + 3 * binWidthAndSpace + gdv(storage_bin, "x") + 10, zShelf2 + shelfThickness])
    rotate([0, 0, 0])
    draw_vertical_2x4(storage_bin);    

    //Second shelf row2
    translate([x10 + gdv(storage_bin, "x") + 25, y4, zShelf2 + shelfThickness])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    translate([x10 + gdv(storage_bin, "x") + 25, y4 + binWidthAndSpace, zShelf2 + shelfThickness])
    rotate([0, 0, 90])
    draw_vertical_2x4(storage_bin);

    translate([x10 + gdv(storage_bin, "x") + 25, y4 + 2 * binWidthAndSpace, zShelf2 + shelfThickness])
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
    color(gdv(board, "color"), 0.5)
    rotate(gdv(board, "rotate"))
    translate(gdv(board, "move"))
    linear_extrude(gdv(board, "z"))
    square(size=[gdv(board, "x"), gdv(board, "y")], center=false);
}