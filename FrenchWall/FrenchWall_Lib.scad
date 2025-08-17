/*
    FrenchWall_Lib.scad

    This file contains library functions and modules for the French Wall project.
    It includes various properties and modules for different components used in the project.
    It is designed to be included in other SCAD files for modular design.
    Use this file to define properties and modules that can be reused across different parts of the project.
    This file is part of the French Wall project.
    It is intended to be used with OpenSCAD for 3D modeling and printing.

    The goal of this is attach a cleat to a tray, and then attach the tray to the wall.

*/


include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

// Uncomment to show ruler in drawing
// scale(size = 5, increment = 10, fontsize = 8);

/*
    Dictionaries for use in Library files.
*/
    tray_x = convert_in2mm(3);
    tray_y = convert_in2mm(0.8);    
    tray_z = convert_in2mm(0.75);
    tray_move = [0, 0, 0];
    tray_rotate = [0, 0, 0];
    tray_color = "LightGrey";
    cleat_print_rotaation = [0, 90, 0];


    tray = 
    ["tray", 
        ["x", tray_x],
        ["y", tray_y],
        ["z", tray_z],
        ["move", tray_move],
        ["rotate", tray_rotate],
        ["color", tray_color]   
    ];

    dowel = 
    ["triangle dowel",
        ["x", convert_in2mm(0.4)],
        ["y", convert_in2mm(0.4)],
        ["z", convert_in2mm(1.0)],
        ["move", [0, convert_in2mm(0.20), 2]],
        ["rotate", [90, 0, 0]],
        ["Add bevel", 1],
        ["Bevel vector", [0, 0.01, 2]],
        ["color", "Yellow"]
    ];

    build_this = ["build this", 
                    ["drawCleat", 0], 
                    ["dowels", 1], 
                    ["drawTray", 0], 
                    ["drawPegTray", 0],
                    ["both", 0],
                    ["peg Tray", 1]
                ];
    build_tray = ["peg Tray", ""];



build(build_this, build_tray); // Change index to build different components

module build(part, trayType) 
{
    // echo("part", part);
    echo("tray", tray);


    if(gdv(part, "drawCleat") == 1)
    {
        echo("Drawing cleat ");
        rotate(cleat_print_rotaation) 
        difference()
        {
            if(gdv(part, "drawPegTray") == 1)
            {
                echo("Drawing peg tray with cleat");
                draw_Cleat(Cleat_for_Peg_Tray);
                echo();
                echo("FileName = FrenchWall_Peg_Cleat.stl");
                echo();                
            }
            else
            {
                echo("Drawing regular tray with cleat");
                draw_Cleat(Backwall);
                echo();
                echo("FileName = FrenchWall_Cleat.stl");
                echo();
            }     
            draw_dowels(tray_x);       
        }                               
    }
    if(gdv(part, "drawTray") == 1)
    {
        echo("Drawing tray with part: ", tray);
        difference()
        {
            union()
            {
                draw_Tray(tray);
                if(gdv(part,"peg Tray")==1)
                {
                    echo("Drawing peg tray");
                    draw_Peg_Tray(Peg);
                }
                else
                {
                    echo("Drawing regular tray");
                }
            }           
            draw_dowels(tray_x);
        }
        
        echo();
        echo("FileName = FrenchWall_Tray.stl");
        echo();
    }
    if (gdv(part, "dowels") == 1)
    {
        echo("Drawing dowels with part: ", dowel);
        draw_dowels(tray_x);

        echo();
        echo("FileName = FrenchWall_Dowels.stl");
        echo();
    }
    if (gdv(part, "both") == 1)
    {
        echo("Drawing both cleat and tray");
        difference()
        {
            union()
            {
                if(gdv(part,"peg Tray")==1)
                {
                    echo("Drawing peg tray with cleat");
                    draw_Cleat(Cleat_for_Peg_Tray);
                }
                else
                {
                    echo("Drawing regular tray with cleat");
                    draw_Cleat(Backwall);
                }
                
                draw_Tray(tray);
            }           
            #draw_dowels(tray_x);
        }

    }
    else
    {
        echo("Unknown argument: ", part);
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

module draw_Cleat(properties) 
{
    // body...
    echo("Drawing cleat with args: ", properties);
    //move to positive 0 x-axis.
    // translate([gdv(properties,"x"),0,0])
    //rotate so cleat is external and wall is located at 0 y-axis
    //rotate([0,90,180])
    union()
    {
        //draw wall
        drawSquareShape(properties);    
        // square([gdv(properties, "x"), gdv(properties, "y")]);
        //draw cleat
        translate([0, gdv(properties,"y"), gdv(properties,"z")])
        draw_parallelogram(gdv(properties, "cleat"));
    }
}

module draw_dowels(xValue)
{
        // Draw dowels
        for (x = [5 : 26 : xValue])
        {
            translate([x, 0, 0])
            draw_triangle_Dowel(dowel);
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
                        // translate([x, 0, 0])
                        translate([gdv(properties, "x"), 0, 0])
                        rotate([0, 180, 0])
                        for(x = [gdv(properties, "Bevel vector").x : gdv(properties, "Bevel vector").y : gdv(properties, "Bevel vector").z])
                        {                            
                            // Draw the triangle dowel as a polygon
                            linear_extrude(height=x)
                            offset(delta = -x, chamfer = true)
                            polygon(points=points, paths=[[0, 1, 2]]);
                        }
                        linear_extrude(height=gdv(properties, "z") - ( 2 * gdv(properties, "Bevel vector").z))
                        polygon(points=points, paths=[[0, 1, 2]]);

                        translate([0, 0, gdv(properties, "z") - (2 * gdv(properties, "Bevel vector").z)])
                        rotate([0, 0, 0])
                        for(x = [gdv(properties, "Bevel vector").x : gdv(properties, "Bevel vector").y : gdv(properties, "Bevel vector").z])
                        {                            
                            // Draw the triangle dowel as a polygon
                            linear_extrude(height=x)
                            offset(delta = -x, chamfer = true)
                            polygon(points=points, paths=[[0, 1, 2]]);
                        }                        
                    }
                }
                else                
                {
                    // Draw the triangle dowel as a polygon without bevel
                    // Apply extrusion to the triangle dowel
                    applyExtrude(properties) 
                    {
                        // Draw the triangle dowel as a polygon
                        polygon(points=points, paths=[[0, 1, 2]]);
                    }
                }

            }
        }       
    }
}

module draw_Peg_Tray(properties) 
{
    echo("Drawing peg tray with properties: ", properties);


    applyColor(properties) 
    {
        // applyRotate(properties) 
        {
            // translate([gdv(properties, "from edge"),0,0])
            translate([5, - (tray_y -5), 0])
            drawCircleShape(properties);
            
            // translate([2 * gdv(properties, "from edge"),0,0])
            translate([57, - (tray_y - 5), 0])
            drawCircleShape(properties);
        }
    }
}   