/*
    French Wall Tray Maker
    by Steven Mitchell
    https://www.thingiverse.com/steven_mitchell/about
    
    This is a module to make trays for the French Wall tool holders.
    Goal is to make it easy to customize trays for different tools.
    This is a work in progress.

*/

/*****************************************************************************
Imports:
  constants.scad - general constants used in many projects.
  ToolHolders_Library.scad - library of tool holder modules.
  ToolHolders_Modules_Library.scad - modules to make tool holders.
  convert.scad - functions to convert between units.
  trigHelpers.scad - functions for trigonometry.
  ObjectHelpers.scad - functions to help with object manipulation.
  dictionary.scad - functions to help with dictionaries.
*****************************************************************************/
include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

/*****************************************************************************
CONSTANTS
*****************************************************************************/
$fn=60;
PI = 4 * atan2(1,1);

TRIANGLE = [[0,0],[0,1],[1,0]];

tray_x = convert_in2mm(3);
tray_y = convert_in2mm(0.6);    
tray_z = convert_in2mm(0.75);

dowel_length = tray_y;
dowel_xyz = [convert_in2mm(0.4), convert_in2mm(0.4), convert_in2mm(0.8)];
dowel_diameter = convert_in2mm(3/8);

tray_move = [0, 0, 0];
tray_rotate = [0, 0, 0];
tray_color = "LightGrey";

// Define peg positions
pegs2 = 
        [
            ["peg1", [5, (tray_y) - 15.5,0]],
            ["peg2", [57, (tray_y - 15.5),0]]
        ];

// Define cleat properties        
cleat_print_rotaation = [0, 90, 0];
cleat_thickness = 5.2;
cleat_length = convert_in2mm(2.5);
cleat_move = [0, 0, 0];

parallelogram = 
["parallelogram properties", 
    ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
    ["parallelogram thickness", cleat_thickness],
    ["angle", 135],
    ["extrude height", tray_x],
];

dowel = 
["triangle dowel",
    ["x", dowel_xyz.x],
    ["y", dowel_xyz.y],
    ["z", dowel_xyz.z],
    ["move", [0, convert_in2mm(0.25), 2]], // Change Y to adjust dowel penetration into cleat wall.
    ["from edge", 0],
    ["rotate", [90, 0, 0]],
    ["Add bevel", 1],
    ["Bevel vector", [0, 0.01, 2]],
    ["color", "Yellow"]
];

tray = 
["tray", 
    ["x", tray_x],
    ["y", tray_y],
    ["z", tray_z],
    ["move", tray_move],
    ["rotate", tray_rotate],
    ["color", tray_color]   
];

this_peg = 
["Peg dimension",
    ["x", convert_in2mm(3/8)],
    ["y", convert_in2mm(3/8)],
    ["z", convert_in2mm(4)], //length of peg
    ["from edge", (tray_x - convert_in2mm(1))/2],
    ["fragments", 60],
    ["move", [0,0,0]],
    ["rotate", [90, 0, 0]],
    ["color", "LightBlue"]
];

// thisCleat is a template for cleats to be used with trays and this_peg trays.
// Modify the x and z values to change the size of the cleat to match the tray.
// The y value is set by the cleat_thickness constant.
//
thisCleat = 
["cleat properties", 
    ["x", tray_x],
    ["y",cleat_thickness],
    ["z", cleat_length], // change z to change cleat height
    ["parallelogram length", cleat_length/sin(45) ],
    ["parallelogram thickness", cleat_thickness],
    ["angle", 135],
    ["extrude height", tray_x],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"]
];

/*****************************************************************************
FUNCTIONS - code to make reading modules easier to understand.
******************************************************************************/
function half(x) = x/2;
function wedgeIncrement(height,i) = i * half(height)/(BRACE_THICKNESS)+half(height);

/*****************************************************************************
Directives - defines what to build with optional features.
*****************************************************************************/
build_this = ["build this", 
                ["drawCleat", 0], 
                ["dowels", 0], 
                ["drawTrayBase", 0], 
                ["drawPegTray", 0],
                ["Re-enforced 2 Long Pegs Tray", 1],
                ["both", 0],
                ["peg Tray", 0],
                ["2 pegs", 0]
            ];

/*****************************************************************************
MAIN SUB - where the instructions start.
*****************************************************************************/
build(build_this);

/*****************************************************************************
MODULES: - the meat of the project.
*****************************************************************************/
module build(directives) 
{
    echo();
    echo();

    if (gdv(directives, "drawCleat") == 1) 
    {
        draw_cleat_module(thisCleat);
    }
    if (gdv(directives, "dowels") == 1) 
    {
        draw_dowels(tray_x);
    }    
    if (gdv(directives, "drawTrayBase") == 1) 
    {
        tray_module(tray);
    }
    if (gdv(directives, "drawPegTray") == 1) 
    {
        difference()
        {
            union()
            {
                tray_module(tray);
                draw_2Pegs(this_peg);
            }

            draw_dowels(tray_x);
        }
    }
    if (gdv(directives, "Re-enforced 2 Long Pegs Tray") == 1) 
    {
        echo("Building Re-enforced 2 Long Pegs Tray.stl");
        echo();
        echo();        
        draw_peg_tray_module();
    }
    if( gdv(directives, "2 pegs") == 1)
    {
        draw_2Pegs(this_peg);
    }
}

/*
MODULES to make the objects.
*/

module draw_peg_tray_module() 
{
            difference()
        {
            union()
            {
                tray_module(tray);
                translate([pegs2[0][1].x, pegs2[0][1].y, 0])
                translate([4.75, -gdv(this_peg, "z")/2, 5])
                cube(size=[6, gdv(this_peg, "z")-2, 10], center=true);

                translate([pegs2[1][1].x, pegs2[1][1].y, 0])
                translate([4.75, -gdv(this_peg, "z")/2, 5])
                cube(size=[6, gdv(this_peg, "z")-2, 10], center=true);

                translate([0,-0.75,0])
                rotate([-5,0,0])
                draw_2Pegs(this_peg);
            }

            draw_dowels(tray_x);
        }
}
module draw_cleat_module(properties, exclude_dowels=true) 
{
    // translate(gdv(properties, "move"))
        // rotate(gdv(properties, "rotate"))
                // body...
            echo("Drawing cleat with args: ", properties);
            //move to positive 0 x-axis.
            translate(cleat_move)
            //rotate so cleat is external and wall is located at 0 y-axis
            //rotate([0,90,180])
            difference()
            {
                union()
                {
                    //draw wall
                    drawSquareShape(properties);    
                    // square([gdv(properties, "x"), gdv(properties, "y")]);
                    //draw cleat
                    translate([0, gdv(properties,"y"), gdv(properties,"z")])
                    draw_parallelogram(parallelogram);
                } 

                if( exclude_dowels == true)
                {
                    draw_dowels(tray_x);
                }
                              
            }

}

module tray_module(tray) 
{
    translate(gdv(tray, "move"))
        rotate(gdv(tray, "rotate"))
        difference()
        {
            draw_Tray(tray);

            draw_dowels(tray_x);
        }
}

module peg_tray_module(tray, backwall, peg_cleat) 
{
    translate(gdv(tray, "move"))
        rotate(gdv(tray, "rotate"))
            peg_tray_maker(tray, backwall, peg_cleat);
}

module draw_dowels(xValue)
{
        // Draw dowels
        for (x = [15 : 26 : xValue])
        {
            translate([x, 0, dowel_diameter/2])
            // draw_triangle_Dowel(dowel);
            #draw_cylendar_dowel(dowel);
        }        
}

module draw_cylendar_dowel(properties) 
{
    echo("Drawing cylinder dowel with properties: ", properties);
    applyColor(properties) 
    {
        applyMove(properties) 
        {
            // Apply rotation to the cylinder dowel
            applyRotate(properties) 
            {
                if(gdv(properties, "Add bevel") == 1)
                {
                    union()
                    {
                        // Apply bevel to the cylinder dowel                    
                        // translate([0, 0, -gdv(properties, "Bevel vector").z]) 
                        cylinder(h = gdv(properties, "Bevel vector").z, d1 = dowel_diameter/2, d2 = dowel_diameter);

                        // Draw the main part of the dowel without bevel
                        translate([0, 0, gdv(properties, "Bevel vector").z]) 
                        cylinder(h = gdv(properties, "z") - ( 2 * gdv(properties, "Bevel vector").z), d=dowel_diameter);

                        translate([0, 0, gdv(properties, "z") - (gdv(properties, "Bevel vector").z)])
                        cylinder(h = gdv(properties, "Bevel vector").z, d1 = dowel_diameter, d2 = dowel_diameter/2);
                    }
                }
                else                
                {
                    assert(false, "No Bevel, not implemented yet.");
                    // Draw the cylinder dowel as a circle without bevel
                    // Apply extrusion to the cylinder dowel
                    applyExtrude(properties) 
                    {
                        // Draw the cylinder dowel as a circle
                        cylinder(h = gdv(properties, "z"), d=dowel_diameter);
                    }
                }

            }
        }       
    }
}

module draw_triangle_Dowel(properties) 
{
    // echo("Drawing triangle dowel with properties: ", properties);
    points = 
        [
            [0, 0],
            [gdv(properties, "x"), 0],
            [gdv(properties, "x")/2, gdv(properties, "y")]
        ];
    applyColor(properties) 
    {
        applyMove(properties) 
        {
            // Apply rotation to the triangle dowel
            applyRotate(properties) 
            {
                if(gdv(properties, "Add bevel") == 1)
                {
                    union()
                    {
                        // Apply bevel to the triangle dowel                    
                        // Draw the triangle dowel as a polygon with bevel
                        // translate([gdv(properties, "x"), 0, 0]) //when dowel is a cilinder no need to move it.
                        rotate([0, 180, 0]) // cilinder is drawn in the opposite direction.
                        for(x = [gdv(properties, "Bevel vector").x : gdv(properties, "Bevel vector").y : gdv(properties, "Bevel vector").z])
                        {                            
                            // Draw the triangle dowel as a polygon
                            linear_extrude(height=x)
                            offset(delta = -x, chamfer = true)
                            // polygon(points=points, paths=[[0, 1, 2]]);
                            circle(d=dowel_diameter);
                        }

                        // Draw the main part of the dowel without bevel
                        linear_extrude(height=gdv(properties, "z") - ( 2 * gdv(properties, "Bevel vector").z))
                        // polygon(points=points, paths=[[0, 1, 2]]);
                        circle(d=dowel_diameter);

                        translate([0, 0, gdv(properties, "z") - (2 * gdv(properties, "Bevel vector").z)])
                        rotate([0, 0, 0])
                        for(x = [gdv(properties, "Bevel vector").x : gdv(properties, "Bevel vector").y : gdv(properties, "Bevel vector").z])
                        {                            
                            // Draw the triangle dowel as a polygon
                            linear_extrude(height=x)
                            offset(delta = -x, chamfer = true)
                            // polygon(points=points, paths=[[0, 1, 2]]);
                            circle(d=dowel_diameter);
                        }                        
                    }
                }
                else                
                {
                    assert(false, "No Bevel, not implemented yet.");
                    // Draw the triangle dowel as a polygon without bevel
                    // Apply extrusion to the triangle dowel
                    applyExtrude(properties) 
                    {
                        // Draw the triangle dowel as a polygon
                        // polygon(points=points, paths=[[0, 1, 2]]);
                    }
                }

            }
        }       
    }
}

module draw_Tray(properties) 
{
    echo("Drawing tray with properties: ", properties);
    applyColor(properties) 
    {
        applyRotate(properties) 
        {
            // applyExtrude(properties) 
            // {
                echo("Drawing tray with dimensions: ", gdv(properties, "x"), gdv(properties, "y"), gdv(properties, "z"));
                // Draw the tray as a cube with the specified dimensions
                // cube([gdv(properties, "x"), gdv(properties, "y"), gdv(properties, "z")]);
                translate([0, -gdv(properties, "y"),0])
                linear_extrude(height=gdv(properties, "z")) 
                {
                    // Use rectangle for 2D representation
                    square([gdv(properties, "x"), gdv(properties, "y")]);
                }
            // }
        }
    }
}

module draw_2Pegs(properties) 
{

    applyColor(properties) 
    {
        // applyRotate(properties) 
        {
            translate([pegs2[0][1].x, pegs2[0][1].y, 0])
            drawCircleShape(properties);
            
            translate([pegs2[1][1].x, pegs2[1][1].y, 0])
            drawCircleShape(properties);
        }
    }
} 
