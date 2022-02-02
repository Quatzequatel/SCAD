/*
    
*/

include <constants.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

///
/// property definitions
///

//shared values
greenhouse_tray_x = convert_in2mm(7);
greenhouse_tray_y = convert_in2mm(3);
greenhouse_tray_z = convert_in2mm(0.5);

Greenhouse_Tray = 
[
    "tray", 
    ["x", greenhouse_tray_x],
    ["y", greenhouse_tray_y],
    ["z", convert_in2mm(0.5)],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];


cleat = 
["cleat properties", 
    ["x", greenhouse_tray_x],
    ["y", NozzleWidth * 8],
    ["z", convert_in2mm(0.75)],
    ["parallelogram length", convert_in2mm(0.75) ],
    ["parallelogram thickness", NozzleWidth * 8],
    ["angle", 135],
    ["extrude height", greenhouse_tray_x],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"]
];

backwall = 
["backwall", 
    ["x", greenhouse_tray_x],
    ["y", NozzleWidth * 8],
    ["z", convert_in2mm(2.5)],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0,0, 0]],
    ["include cleat", false],
    ["cleat", cleat],
    ["color", "LightGrey"]
];


///    
/// objects
///

build();

module build(args) 
{
    draw_Cleated_Back_Wall(backwall);
    draw_tray();

    // draw_bracket_for_support_cleat();

    draw_drill_bit_holes();
    
}


/*
    drawing methods.
*/

module draw_Cleated_Back_Wall(properties)
{
    //now wall and cleat is at [0,0]
    //move to positive 0 x-axis.
    translate([gdv(properties,"x"),0,0])
    //rotate so cleat is external and wall is located at 0 y-axis
    rotate([0,0,180])
    union()
    {
        //draw wall
        drawSquareShape(properties);    
        //draw cleat
        translate([0, gdv(properties,"y"), gdv(properties,"z")])
        draw_parallelogram(gdv(properties, "cleat"));
    }
}

module draw_tray()
{
    drawSquareShape(Greenhouse_Tray);
}

module draw_drill_bit_holes()
{

}

module draw_bracket_for_support_cleat() 
{
    length = convert_in2mm(2);
    height = convert_in2mm(3);
    depth = convert_in2mm(0.75);
    angle =45;

    bracket = 
    [
        "bracket", 
        ["x", convert_in2mm(2)],
        ["y", depth/2 + height - (depth * tan(angle))],
        ["z", convert_in2mm(1)],
        ["move", [0, 0, 0]],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
    ];

    difference()
    {
        // translate([-gdv(bracket, "y")/2, gdv(bracket, "z"), 0])
        drawSquareShape(bracket);

        translate([gdv(bracket, "x")/2 - depth/2, depth/2, -1])
        #draw_support_cleat(length, height, depth, 45);

        //bottom left
        translate([(gdv(bracket, "x")/2 - depth/2)/2, depth/2, depth-1])
        cylinder(h= 2 * depth, r = woodscrewThreadRad, center = true);

        //bottom right
        translate([(gdv(bracket, "x") - (gdv(bracket, "x")/2 - depth/2)/2), depth/2, depth-1])
        cylinder(h= 2 * depth, r = woodscrewThreadRad, center = true);   

        //top left
        translate([(gdv(bracket, "x")/2 - depth/2)/2, gdv(bracket, "y") - depth/2, depth-1])
        cylinder(h= 2 * depth, r = woodscrewThreadRad, center = true);

        //top right
        translate([(gdv(bracket, "x") - (gdv(bracket, "x")/2 - depth/2)/2), gdv(bracket, "y") - depth/2, depth-1])
        cylinder(h= 2 * depth, r = woodscrewThreadRad, center = true);
    }
    
}

module draw_support_cleat(length, height, depth, angle)
{
    // AB = depth;  //length of side A-B
    // DA = height; // lenght of side D-A
    // //cleat is a right angle triangle on top of a retangle.
    // //height is side A of the triangle
    // EA = depth * tan(angle); 
    // BC = height - EA;
    support_cleat = 
    ["support_cleat", 
        ["A", [0,0] ],
        ["B", [depth, 0] ],
        ["C", [depth, height] ],
        ["D", [0, height - (depth * tan(angle))] ],        
        ["length", length],
        ["move", [0, 0, 0] ], 
        ["rotate", [ 0, 0, 0] ],
        ["color", "LightGrey"]
    ];

    // properties_echo(support_cleat);

    draw_simple_4sided_polyhedron(support_cleat);
}