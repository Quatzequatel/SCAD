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

cleat = 
["cleat properties", 
    ["x", gdv(tray, "x")],
    ["y", NozzleWidth * 8],
    ["z", convert_in2mm(0.75)],
    ["cleat length", convert_in2mm(0.75) ],
    ["cleat thickness", NozzleWidth * 8],
    ["angle", 135],
    ["extrude height", gdv(tray, "x")],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"]
];

backwall = 
["backwall", 
    ["x", gdv(tray, "x")],
    ["y", NozzleWidth * 8],
    ["z", convert_in2mm(2.5)],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0,0, 0]],
    ["include cleat", false],
    ["cleat", cleat],
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
    ["count", 2],
    ["fragments", 60],
    ["move", [0,0,0]],
    ["from edge", (gdv(HammerTray, "x")-convert_in2mm(1))/2],
    ["rotate", [90,0, 0]],
    ["color", "LightBlue"]
];

screwholes = 
["screwhole dimension",
    ["x", GRK_cabinet_screw_shank_dia],
    ["y", GRK_cabinet_screw_shank_dia],
    ["z", gdv(tray, "z")],
    ["count", 2],
    ["fragments", 60],
    ["move", [0, gdv(backwall, "y") + 1 ,convert_in2mm(2)]],
    ["rotate", [90,0, 0]],
    ["color", "red"]
];

tool_bit_array = 
["tool_bit_array",
    ["x", gdv(tray, "x")],
    ["y", gdv(tray, "y")],
    ["z", gdv(tray, "z")],
    ["columns", 5],
    ["rows", 6],
    ["spacing", 0],
    ["move", [HexBitHoleDia/2, HexBitHoleDia/2, 0]],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
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


screwDriver_array = 
["screwDriver_array",
    // ["x", gdv(screwDriverShaft, "x") * 1.95],
    // ["y", gdv(screwDriverShaft, "y") * 1.25],
    ["x", gdv(screwDriverShaft, "x") * 1.95],
    ["y", gdv(screwDriverShaft, "y") * 1.25],
    ["z", gdv(tray, "z")*2],
    ["xCount", 4],
    ["yCount", 2],
    ["move", [gdv(screwDriverShaft, "x")/2, gdv(screwDriverShaft, "y")/4, 0] ],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

function GetTrayCellLength(v, rows) = ( gdv(v, "x") - gdv(v, "rows") * gdv(v, "spacing") ) / gdv(v, "rows") ;
function GetTrayCellWidth(v, columns) = ( gdv(v, "y") - gdv(v, "columns") * gdv(v, "spacing") )  / gdv(v, "columns") ;

module drawArrayOfCircleShapes(array, bitInfo)
{
    properties_echo(array);
    properties_echo(bitInfo);
    rows = gdv(array, "rows");
    columns = gdv(array, "columns");
    xDistance = GetTrayCellLength(array);
    yDistance = GetTrayCellWidth(array);
    echo(xDistance=xDistance, yDistance=yDistance);
    translate(gdv(array,"move"))
    {
        union()
        {
            for (row=[0:rows-1]) 
            {
                for (col=[0:columns-1]) 
                {
                    echo(ponits =[row * xDistance, col * yDistance, 0]);
                    translate([row * xDistance, col * yDistance, 0])
                    # drawCircleShape(bitInfo);
                }        
            }          
        }        
    }

  
}

module drawSquareShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    rotate(gdv(properties, "rotate"))
    translate(gdv(properties, "move"))
    //move to xy location
    // translate([gdv(properties, "x")/2, gdv(properties, "y")/2])
    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=false);
}

module drawCircleShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    translate(gdv(properties, "move"))
    rotate(gdv(properties, "rotate"))
    translate([gdv(properties, "x")/2, gdv(properties, "y")/2])
    linear_extrude(gdv(properties, "z"))
    circle(d=gdv(properties, "x"), $fn = gdv(properties, "fragments"));
}