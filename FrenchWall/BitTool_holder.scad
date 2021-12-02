/*
    1. bit holder tray for french wall
    2. Back with holes to attach to cleat board.
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

screwhole = 
["screwhole dimension",
    ["x", GRK_cabinet_screw_shank_dia],
    ["y", GRK_cabinet_screw_shank_dia],
    ["z", gdv(tray, "z")],
    ["fragments", 30],
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

build();

module build(args) 
{
    difference()
    {
        union()
        {
        drawSquareShape(tray);
        drawSquareShape(backwall);            
        }
        translate(gdv(tool_bit_array,"move"))
        drawToolBitArray(tool_bit_array, bit);
        drawCircleShape(screwhole);
        translate([gdv(backwall, "from edge"),0,0])
        drawCircleShape(screwhole);
        translate([-gdv(backwall, "from edge"),0,0])
        drawCircleShape(screwhole);
    }
    
}

module drawToolBitArray(array, bitInfo)
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
    // echo(properties = properties);

    color(gdv(properties, "color"), 0.5)
    rotate(gdv(properties, "rotate"))
    translate(gdv(properties, "move"))
    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=true);
}

module drawCircleShape(properties)
{
    // echo(properties = properties);

    color(gdv(properties, "color"), 0.5)
    translate(gdv(properties, "move"))
    rotate(gdv(properties, "rotate"))
    linear_extrude(gdv(properties, "z"))
    circle(d=gdv(properties, "x"), $fn = gdv(properties, "fragments"));
}