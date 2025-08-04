/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

Tray = 
["Tray", 
    ["x", convert_in2mm(5)],
    ["y", convert_in2mm(3)],
    ["z", convert_in2mm(0.5)],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

cleat_thickness = 5.2;

cleat = 
["cleat properties", 
    ["x", gdv(Tray, "x")],
    ["y",cleat_thickness],
    ["z", convert_in2mm(0.75)],
    ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
    ["parallelogram thickness", cleat_thickness],
    ["angle", 135],
    ["extrude height", gdv(Tray, "x")],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"]
];

Backwall = 
["Backwall", 
    ["filename", "Cleat_for_wall.stl"],
    ["x", gdv(Tray, "x")],
    ["y", cleat_thickness],
    ["z", convert_in2mm(3.5)],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0,0, 0]],
    ["include cleat", false],
    ["cleat", cleat],
    ["color", "LightGrey"]
];

Peg_Cleat = 
["cleat properties", 
    ["x", convert_in2mm(3)],
    ["y",cleat_thickness],
    ["z", convert_in2mm(0.75)],
    ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
    ["parallelogram thickness", cleat_thickness],
    ["angle", 135],
    ["extrude height", convert_in2mm(3)],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"]
];

Cleat_for_Peg_Tray = 
["Cleat_for_Peg_Tray", 
    ["filename", "Cleat_for_Peg_Tray.stl"],
    ["x", convert_in2mm(3)],
    ["y", cleat_thickness],
    ["z", convert_in2mm(3.5)],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0,0, 0]],
    ["include cleat", false],
    ["cleat", Peg_Cleat],
    ["color", "LightGrey"]
];





Bit = 
["bit dimension",
    ["x", HexBitHoleDia],
    ["y", HexBitHoleDia],
    ["z", gdv(Tray, "z")],
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
["HammerBackwall", 
    ["x", gdv(HammerTray, "x")],
    ["y",cleat_thickness],
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
    // ["move", [0,gdv(HammerBackwall, "move").y,convert_in2mm(3/8)/2]],
    ["move", [0,0,0]],
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
    ["z", gdv(Tray, "z")],
    ["count", 2],
    ["fragments", 60],
    ["move", [0, gdv(Backwall, "y") + 1 ,convert_in2mm(2)]],
    ["rotate", [90,0, 0]],
    ["color", "red"]
];

tool_bit_array = 
["tool_bit_array",
    ["x", gdv(Tray, "x")],
    ["y", gdv(Tray, "y")],
    ["z", gdv(Tray, "z")],
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
    ["z", gdv(Tray, "z") * 1.25],
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
    ["z", gdv(Tray, "z")*2],
    ["xCount", 4],
    ["yCount", 2],
    ["move", [gdv(screwDriverShaft, "x")/2, gdv(screwDriverShaft, "y")/4, 0] ],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];


