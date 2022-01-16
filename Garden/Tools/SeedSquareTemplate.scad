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
    ["x", convert_in2mm(0.5)],
    ["y", convert_in2mm(0.5)],
    ["z", convert_in2mm(0.5) + gdv(SeedSquare, "z")],
    ["fragments", 60],
    ["move", [0,0,0]],
    ["rotate", [0,0, 90]],
    ["color", "green"]
];

SeedHole2 = 
["SeedHole dimension",
    ["height", gdv(SeedSquare, "z")],
    ["r1", convert_in2mm(0.3)],
    ["r2", convert_in2mm(0)],
    ["fragments", 60],
    ["move", [0,0,gdv(SeedSquare, "z")/2]],
    ["rotate", [0,0, 90]],
    ["color", "green"]
];

SeedVestibule = 
["Seed vestibule dimension",
    ["x", convert_in2mm(0.33)],
    ["y", convert_in2mm(0.5)],
    ["z", convert_in2mm(0.7) + gdv(SeedSquare, "z")],
    ["fragments", 60],
    ["move", [0,0,0]],
    ["rotate", [0,0, 90]],
    ["color", "green"]
];

HandleHole = 
["Handle Hole dimension",
    ["count", 2],
    ["x", convert_in2mm(1)],
    ["y", convert_in2mm(3)],
    ["z", convert_in2mm(0.1) + gdv(SeedSquare, "z")],
    ["fragments", 60],
    ["move", [convert_in2mm(-1.5),convert_in2mm(-2),convert_in2mm(0)]],
    ["rotate", [0,0, 90]],
    ["color", "green"]
];

SixSeedingTray_Cell = 
[
    "SixSeedingTray_Cell",
    ["x", convert_in2mm(1.57)],
    ["y", convert_in2mm(1.57)],
    ["z", gdv(SeedSquare, "z") + 2],
    ["SeedHole", SeedHole],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

SixSeedingTray = 
[
    "SixSeedingTray",
    ["rows", 2],
    ["columns", 1],
    ["x",  gdv(SixSeedingTray_Cell, "x") * 3],
    ["y",  gdv(SixSeedingTray_Cell, "y") * 2],
    ["z", gdv(SeedSquare, "z")],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

SeedHole_array6 = 
["SeedHole_array",
    ["rows", 3],
    ["columns", 5],
    ["x", convert_in2mm(1.57)],
    ["y", convert_in2mm(1.57)],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

SeedHole_array5 = 
["SeedHole_array",
    ["holes count", 5],
    ["location 1", [convert_in2mm(3), convert_in2mm(3), 0]],
    ["location 2", [convert_in2mm(-3), convert_in2mm(3), 0]],
    ["location 3", [convert_in2mm(-3), convert_in2mm(-3), 0]],
    ["location 4", [convert_in2mm(3), convert_in2mm(-3), 0]],
    ["location 5", [convert_in2mm(0), convert_in2mm(0), 0]],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

SeedHole_array9 = 
["SeedHole_array",
    ["holes count", 9],
    ["location 1", [convert_in2mm(2), convert_in2mm(2), 0]],
    ["location 2", [convert_in2mm(2), convert_in2mm(6), 0]],
    ["location 3", [convert_in2mm(2), convert_in2mm(10), 0]],
    ["location 4", [convert_in2mm(6), convert_in2mm(2), 0]],
    ["location 5", [convert_in2mm(6), convert_in2mm(6), 0]],
    ["location 6", [convert_in2mm(6), convert_in2mm(10), 0]],
    ["location 7", [convert_in2mm(10), convert_in2mm(2), 0]],
    ["location 8", [convert_in2mm(10), convert_in2mm(6), 0]],
    ["location 9", [convert_in2mm(10), convert_in2mm(10), 0]],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

SeedHole_array16 = 
["SeedHole_array",
    ["holes count", 16],
    ["location 1", [convert_in2mm(1.5), convert_in2mm(1.5), 0]],
    ["location 2", [convert_in2mm(1.5), convert_in2mm(4.5), 0]],
    ["location 3", [convert_in2mm(1.5), convert_in2mm(7.5), 0]],
    ["location 4", [convert_in2mm(1.5), convert_in2mm(10.5), 0]],
    ["location 5", [convert_in2mm(4.5), convert_in2mm(1.5), 0]],
    ["location 6", [convert_in2mm(4.5), convert_in2mm(4.5), 0]],
    ["location 7", [convert_in2mm(4.5), convert_in2mm(7.5), 0]],
    ["location 8", [convert_in2mm(4.5), convert_in2mm(10.5), 0]],
    ["location 9", [convert_in2mm(7.5), convert_in2mm(1.5), 0]],
    ["location 10", [convert_in2mm(7.5), convert_in2mm(4.5), 0]],
    ["location 11", [convert_in2mm(7.5), convert_in2mm(7.5), 0]],
    ["location 12", [convert_in2mm(7.5), convert_in2mm(10.5), 0]],
    ["location 13", [convert_in2mm(10.5), convert_in2mm(1.5), 0]],
    ["location 14", [convert_in2mm(10.5), convert_in2mm(4.5), 0]],
    ["location 15", [convert_in2mm(10.5), convert_in2mm(7.5), 0]],
    ["location 16", [convert_in2mm(10.5), convert_in2mm(10.5), 0]],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

// buildSeedTray();
build();

module build(args) 
{
    difference()
    {
        union()
        {
            // translate([convert_in2mm(6),convert_in2mm(6),convert_in2mm(0)])
            drawSquareShape(SixSeedingTray);
            drawArrayOfSquareShapes(SixSeedingTray, SixSeedingTray_Cell);
        }

        // translate([convert_in2mm(4.5),convert_in2mm(4.5),convert_in2mm(0)])
        // drawHullCircles(HandleHole);

        // translate([convert_in2mm(4.5),convert_in2mm(7.5),convert_in2mm(0)])
        // drawHullCircles(HandleHole);

        // drawArrayOfCircleShapes(SeedHole_array9, SeedVestibule);
        // drawArrayOfCylinderShapes(SeedHole_array9, SeedHole2);
    }

}


module drawSquareShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    rotate(gdv(properties, "rotate"))
    // translate(gdv(properties, "move"))
    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=false);
}

module drawCircleShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    // translate(gdv(properties, "move"))
    translate([gdv(properties, "x")/2, gdv(properties, "y")/2])
    // rotate(gdv(properties, "rotate"))
    linear_extrude(gdv(properties, "z"))
    circle(d=gdv(properties, "x"), $fn = gdv(properties, "fragments"));
}

module drawCylinderShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    // translate(gdv(properties, "move"))
    translate([gdv(properties, "x")/2, gdv(properties, "y")/2])
    cylinder(h = gdv(properties, "height"), r1 = gdv(properties, "r1"), r2 = gdv(properties, "r2"), center = true);
}

module drawArrayOfCircleShapes(tray, cell)
{
    properties_echo(tray);
    properties_echo(cell);
    rows = gdv(tray, "rows");
    columns = gdv(tray, "columns");

    xDistance = gdv(cell, "x");
    yDistance = gdv(cell, "y");

    for (row=[0:rows])
    {
        for (column = [0:columns]) 
        {
            // echo(row = row);
            // echo(x=row*xDistance, y=column * yDistance);

            translate([row * xDistance, column * yDistance, 0])
            drawCircleShape(cell);       
        }    
    }
    
}

module drawArrayOfSquareShapes(tray, cell)
{
    // properties_echo(tray);
    // properties_echo(cell);
    rows = gdv(tray, "rows");
    columns = gdv(tray, "columns");
    xDistance = gdv(cell, "x");
    yDistance = gdv(cell, "y");

    for (row=[0:rows])
    {
        for (column = [0:columns]) 
        {
            // echo(x=row * xDistance, y=column * yDistance);
            translate([row * xDistance, column * yDistance, 0])
            difference()
            {
                drawSquareShape(cell); 
            }
                  
        }    
    }
    
}

module drawArrayOfCylinderShapes(array, bitInfo)
{
    rows = gdv(array, "holes count");

    for (row=[1:rows]) 
    {
        translate(gdv(array, str("location ", row)))
        drawCylinderShape(bitInfo);       
    }    
}

module drawHullCircles(properties)
{

    color(gdv(properties, "color"), 0.5)
    // rotate(gdv(properties, "rotate"))
    // translate(gdv(properties, "move"))
    linear_extrude(gdv(properties, "z"))
    hull()
    {
        translate([gdv(properties, "y"),0,0])
        circle(d=gdv(properties, "x"), $fn = gdv(properties, "fragments"));
        circle(d=gdv(properties, "x"), $fn = gdv(properties, "fragments"));
    }

}

module buildSeedTray(args) 
{
    difference()
    {
        union()
        {
            // translate([convert_in2mm(6),convert_in2mm(6),convert_in2mm(0)])
            drawSquareShape(SeedSquare);
            drawArrayOfCircleShapes(SeedHole_array9, SeedHole);
        }

        translate([convert_in2mm(4.5),convert_in2mm(4.5),convert_in2mm(0)])
        drawHullCircles(HandleHole);

        translate([convert_in2mm(4.5),convert_in2mm(7.5),convert_in2mm(0)])
        drawHullCircles(HandleHole);

        drawArrayOfCircleShapes(SeedHole_array9, SeedVestibule);
        drawArrayOfCylinderShapes(SeedHole_array9, SeedHole2);
    }

}