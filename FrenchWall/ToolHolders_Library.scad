/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

tray = 
["tray", 
    ["x", convert_in2mm(5)],
    ["y", convert_in2mm(3)],
    ["z", convert_in2mm(0.5)],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

backwall = 
["backwall", 
    ["x", gdv(tray, "x")],
    ["y", NozzleWidth * 8],
    ["z", convert_in2mm(2.5)],
    ["move", [0, convert_in2mm(3)/2, 0]],
    ["from edge", (gdv(tray, "x")-convert_in2mm(0.75))/2],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

bit = 
["bit dimension",
    ["x", HexBitHoleDia],
    ["y", HexBitHoleDia],
    ["z", gdv(tray, "z")],
    ["fragments", 6],
    ["move", [0,0,LayersToHeight(6)]],
    ["rotate", [0,0, 0]],
    ["color", "LightBlue"]
];

screwDriverShaft = 
["bit dimension",
    ["x", convert_in2mm(0.5)],
    ["y", convert_in2mm(0.75)],
    ["z", gdv(tray, "z") * 1.25],
    ["fragments", 60],
    ["move", [0,0,LayersToHeight(-2)]],
    ["rotate", [0,0, 0]],
    ["color", "lightYellow"]
];


HammerTray = 
["HammerTray", 
    ["x", convert_in2mm(3)],
    ["y", convert_in2mm(2)],
    ["z", convert_in2mm(0.5)],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

HammerHead = 
["HammerHead",
    ["x", convert_in2mm(1.5)],
    ["y", convert_in2mm(1.5)],
    ["z", convert_in2mm(6)],
    ["fragments", 200],
    ["move", [-convert_in2mm(6)/2,0,convert_in2mm(1.5)/2 + LayersToHeight(8)]],
    ["rotate", [0,90, 0]],
    ["color", "LightBlue"]
];

HammerShaft = 
["HammerHead",
    ["x", gdv(HammerHead, "x")],
    ["y", gdv(HammerHead, "y")],
    ["z", gdv(HammerHead, "z")],
    ["fragments", gdv(HammerHead, "fragments")],
    ["move", [0,0,-gdv(HammerHead, "z")/2]],
    ["rotate", [0,0,0]],
    ["color", "LightBlue"]
];

HammerShaper = 
["HammerHead",
    ["x", convert_in2mm(0.8)],
    ["y", convert_in2mm(0.8)],
    ["z", convert_in2mm(6)],
    ["fragments", gdv(HammerHead, "fragments")],
    ["move", [0,0,0]],
    ["rotate", [0,0,0]],
    ["color", "LightBlue"]
];
HammerShapperTray = 
["HammerTray", 
    ["x", gdv(HammerTray, "x")/2],
    ["y", gdv(HammerTray, "y")/2],
    ["z", gdv(HammerTray, "z")+3],
    ["move", [0, 0, -1]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

HammerBackwall = 
["backwall", 
    ["x", gdv(HammerTray, "x")],
    ["y", NozzleWidth * 8],
    ["z", convert_in2mm(2)],
    ["move", [0, gdv(HammerTray, "y")/2, 0]],
    ["from edge", (gdv(HammerTray, "x")-convert_in2mm(0.75))/2],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

Peg = 
["Peg dimension",
    ["x", convert_in2mm(3/8)],
    ["y", convert_in2mm(3/8)],
    ["z", convert_in2mm(2)],
    ["fragments", 60],
    ["move", [0,gdv(HammerBackwall, "move").y,convert_in2mm(3/8)/2]],
    ["from edge", (gdv(HammerTray, "x")-convert_in2mm(1))/2],
    ["rotate", [90,0, 0]],
    ["color", "LightBlue"]
];

DrillPeg = 
["Drill Peg dimension",
    ["x", convert_in2mm(4/8)],
    ["y", convert_in2mm(4/8)],
    ["z", convert_in2mm(5)],
    ["fragments", 60],
    ["move", [0,gdv(HammerBackwall, "move").y,convert_in2mm(4/8)/2]],
    ["from edge", (gdv(HammerTray, "x")-convert_in2mm(1))/2],
    ["rotate", [90,0, 0]],
    ["color", "LightBlue"]
];

screwhole = 
["screwhole dimension",
    ["x", GRK_cabinet_screw_shank_dia],
    ["y", GRK_cabinet_screw_shank_dia],
    ["z", gdv(tray, "z")],
    ["fragments", 60],
    ["move", [0,convert_in2mm(1.7),convert_in2mm(2)]],
    ["rotate", [90,0, 0]],
    ["color", "red"]
];

tool_bit_array = 
["tool_bit_array",
    ["x", HexBitHoleDia * 1.25],
    ["y", HexBitHoleDia * 1.25],
    ["z", gdv(tray, "z")],
    ["xCount", 11],
    ["yCount", 6],
    ["move", [-7 * HexBitHoleDia, -4 * HexBitHoleDia, 0]],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

screwDriver_array = 
["screwDriver_array",
    ["x", gdv(screwDriverShaft, "x") * 1.95],
    ["y", gdv(screwDriverShaft, "y") * 1.25],
    ["z", gdv(tray, "z")*2],
    ["xCount", 4],
    ["yCount", 2],
    ["move", [-4 * gdv(screwDriverShaft, "x"), -1.4 * gdv(screwDriverShaft, "y"), 0]],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

module drawArrayOfCircleShapes(array, bitInfo)
{
    rows = gdv(array, "xCount");
    columns = gdv(array, "yCount");
    xDistance = gdv(array, "x");
    yDistance = gdv(array, "y");
    for (row=[0:rows]) 
    {
        for (col=[0:columns]) 
        {
            translate([row * xDistance, col * yDistance, 0])
            drawCircleShape(bitInfo);
        }        
    }    
}

module drawSquareShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    rotate(gdv(properties, "rotate"))
    translate(gdv(properties, "move"))
    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=true);
}

module drawCircleShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    translate(gdv(properties, "move"))
    rotate(gdv(properties, "rotate"))
    linear_extrude(gdv(properties, "z"))
    circle(d=gdv(properties, "x"), $fn = gdv(properties, "fragments"));
}