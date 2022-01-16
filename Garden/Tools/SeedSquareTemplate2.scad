/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

SeedSquare = 
["Seed Square", 
    ["x", convert_in2mm(12)],
    ["y", convert_in2mm(12)],
    ["z", convert_in2mm(0.25)],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

SeedHole = 
["SeedHole dimension",
    ["od", convert_in2mm(0.5)],
    ["id", convert_in2mm(0.3)],
    ["d2", convert_in2mm(0.8)],
    ["d1", convert_in2mm(0)],
    ["z", convert_in2mm(0.5) + gdv(SeedSquare, "z")],
    ["vestibule height", gdv(SeedSquare, "z")],
    ["fragments", 60],
    ["move", [0,0,0]],
    ["rotate", [0,0, 90]],
    ["color", "green"]
];

SixSeedingTray = 
[
    "SixSeedingTray",
    ["rows", 3],
    ["columns", 2],
    ["x",  131],
    ["y",  87],
    ["z", gdv(SeedSquare, "z")],
    ["spacing", 4],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

SixSeedingTray_Cell = 
[
    "SixSeedingTray_Cell",
    ["x", GetTrayCellLength(SixSeedingTray)],
    ["y", GetTrayCellWidth(SixSeedingTray)],
    ["z", gdv(SeedSquare, "z") + 2],
    ["spacing", gdv(SixSeedingTray, "spacing")],
    ["SeedHole", SeedHole],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];



function GetTrayCellLength(v, rows) = ( gdv(v, "x") - gdv(v, "rows") * gdv(v, "spacing") ) / gdv(v, "rows") ;
function GetTrayCellWidth(v, columns) = ( gdv(v, "y") - gdv(v, "columns") * gdv(v, "spacing") )  / gdv(v, "columns") ;

Build_SixSeedingTray();

module Build_SixSeedingTray(args) 
{
    union()
    {
        drawCellsForTray(SixSeedingTray, SixSeedingTray_Cell);
        difference()
        {
            translate([0,0,2])
            drawSquareShape(SixSeedingTray);
            drawNegativeCellsForTray(SixSeedingTray, SixSeedingTray_Cell);
        }            
    }
}

module drawCellsForTray(tray, cell)
{
    // properties_echo(tray);
    // properties_echo(cell);
    SeedHole = gdv(cell, "SeedHole");
    // properties_echo(SeedHole);

    rows = gdv(tray, "rows");
    columns = gdv(tray, "columns");
    spacing = gdv(tray, "spacing");
    xDistance = gdv(cell, "x");
    yDistance = gdv(cell, "y");
    radius = gdv(SeedHole, "x")/2;

    // drawSquareShape(SixSeedingTray);
    for (row=[0:rows-1])
    {
        for (column = [0:columns-1]) 
        {
            // echo(x=row * xDistance, y=column * yDistance);
            translate([spacing/2 + row * (xDistance + spacing), spacing/2 + column * (yDistance + spacing), 0])
            difference()
            {
                union()
                {                    
                    drawSquareShape(cell); 
                    translate([xDistance/2, yDistance/2,-1])
                    drawOuterCylinder(SeedHole);          
                              
                }

                translate([xDistance/2, yDistance/2,-1])
                union()
                {
                    drawInnerCylinder(SeedHole);        
                    drawCone(SeedHole);
                }
                
            }                  
        }    
    }    
}

/*/////////////////////////////////
primative drawing methods
*//////////////////////////////////

///
/// Draws a non centered cube from dictionary values
///
module drawSquareShape(properties)
{
    
    color(gdv(properties, "color"), 0.5)
    rotate(gdv(properties, "rotate"))

    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=false);
}

///
/// Draws a non centered cube from dictionary values
///
module drawCircleShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    translate([gdv(properties, "x")/2, gdv(properties, "x")/2])
    // rotate(gdv(properties, "rotate"))
    linear_extrude(gdv(properties, "z"))
    circle(d=gdv(properties, "x"), $fn = gdv(properties, "fragments"));
}

///
/// When using in an array with difference() to seperate the cylinder by drawing outer first
/// then differcing with the inner.
///
module drawOuterCylinder(values)
{
    cylinder(h=gdv(values, "z"), d = gdv(values, "od"), center = true, $fn = gdv(values, "fragments"));
}

///
/// When using in an array with difference() to seperate the cylinder by drawing outer first
/// then differcing with the inner.
///
module drawInnerCylinder(values)
{
    translate([0,0,-1])
    cylinder(h=gdv(values, "z") + 4, d = gdv(values, "id"), center = true, $fn = gdv(values, "fragments"));
}

///
/// draws cylinder with d1 as bottom diameter and d2 as top diameter.
///
module drawCone(values)
{
    cylinder(h=gdv(values, "z") + 4, d1 = gdv(values, "d1"), d2 = gdv(values, "d2"), center = true, $fn = gdv(values, "fragments"));
}

///
/// draws a pipe; od is outer diameter and id is inner diameter.
///
module drawPipe(values)
{
    difference()
    {
        cylinder(h=gdv(values, "z"), d = gdv(values, "od"), center = true, $fn = gdv(values, "fragments"));
        translate([0,0,1])
        cylinder(h=gdv(values, "z")+2, d = gdv(values, "id"), center = true, $fn = gdv(values, "fragments"));
    }
}


module drawNegativeCellsForTray(tray, cell)
{
    rows = gdv(tray, "rows");
    columns = gdv(tray, "columns");
    spacing = gdv(tray, "spacing");
    xDistance = gdv(cell, "x");
    yDistance = gdv(cell, "y");
    // radius = gdv(SeedHole, "x")/2;

    // drawSquareShape(SixSeedingTray);
    for (row=[0:rows-1])
    {
        for (column = [0:columns-1]) 
        {
            // echo(x=row * xDistance, y=column * yDistance);
            translate([spacing/2 + row * (xDistance + spacing), spacing/2 + column * (yDistance + spacing), 0])
                    drawSquareShape(cell);                     
        }    
    }    
}