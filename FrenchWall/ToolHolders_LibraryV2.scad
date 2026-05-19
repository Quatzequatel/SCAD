/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;

TrayStore = 
[   
    ["description", "dimension properties for tool tray"],
    ["x", convert_in2mm(5)],
    ["y", convert_in2mm(3)],
    ["z", convert_in2mm(0.5)],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

cleat_thickness = 5.2;

CleatStore = 
[   
    ["description", "CleatStore"],
    ["x", kv_get(TrayStore, "x")],
    ["y", cleat_thickness],
    ["z", convert_in2mm(0.75)],
    ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
    ["parallelogram thickness", cleat_thickness],
    ["angle", 135],
    ["extrude height", kv_get(TrayStore, "x")],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"]
];

BackwallStore = 
[
    ["description", "BackwallStore"],
    ["filename", "Cleat_for_wall.stl"],
    ["x", kv_get(TrayStore, "x")],
    ["y", cleat_thickness],
    ["z", convert_in2mm(3.5)],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0,0, 0]],
    ["include cleat", false],
    ["cleat", CleatStore],
    ["color", "LightGrey"]
];

Peg_CleatStore = 
[   
    ["description", "Peg_CleatStore"],
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

Cleat_for_Peg_TrayStore = 
[   
    ["description", "Cleat_for_Peg_TrayStore"],
    ["filename", "Cleat_for_Peg_Tray.stl"],
    ["x", convert_in2mm(3)],
    ["y", cleat_thickness],
    ["z", convert_in2mm(3.5)],
    ["move", [0, 0, 0]],
    ["from edge", 0],
    ["rotate", [0,0, 0]],
    ["include cleat", false],
    ["cleat", Peg_CleatStore],
    ["color", "LightGrey"]
];





BitStore = 
[   
    ["description", "BitStore"],
    ["x", HexBitHoleDia],
    ["y", HexBitHoleDia],
    ["z", kv_get(TrayStore, "z")],
    ["fragments", 6],
    ["move", [0,0,LayersToHeight(6)]],
    ["rotate", [0,0, 0]],
    ["color", "LightBlue"]
];



HammerTrayStore = 
[   
    ["description", "HammerTrayStore"],
    ["x", convert_in2mm(3)],
    ["y", convert_in2mm(2)],
    ["z", convert_in2mm(0.5)],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

HammerHeadStore = 
[   
    ["description", "HammerHeadStore"],
    ["x", convert_in2mm(1.5)],
    ["y", convert_in2mm(1.5)],
    ["z", convert_in2mm(6)],
    ["fragments", 200],
    ["move", [-convert_in2mm(6)/2,0,convert_in2mm(1.5)/2 + LayersToHeight(8)]],
    ["rotate", [0,90, 0]],
    ["color", "LightBlue"]
];

HammerShaftStore = kv_merge(HammerHeadStore, 
        [
            ["description", "HammerShaftStore"],
            ["rotate", [0,0,0]],
            ["color", "LightBlue"]
        ]
    );
HammerShaperStore = kv_merge(HammerHeadStore, 
        [
            ["description", "HammerShaperStore"],
            ["x", convert_in2mm(0.8)],
            ["y", convert_in2mm(0.8)],
            ["rotate", [0,0,0]],
            ["color", "LightBlue"]
        ]
    );
HammerShapperTrayStore = kv_merge(HammerTrayStore, 
        [
            ["description", "HammerShapperTrayStore"],
            ["x", kv_get(HammerTrayStore, "x")/2],
            ["y", kv_get(HammerTrayStore, "y")/2],
            ["z", kv_get(HammerTrayStore, "z")+3],
            ["move", [0, 0, -1]],
            ["rotate", [0,0, 0]],
            ["color", "LightGrey"]
        ]
    );
HammerBackwallStore = kv_merge(HammerTrayStore, 
        [
            ["description", "HammerBackwallStore"],
            ["x", kv_get(HammerTrayStore, "x")],
            ["y",cleat_thickness],
            ["z", convert_in2mm(2)],
            ["move", [0, kv_get(HammerTrayStore, "y")/2, 0]],
            ["from edge", (kv_get(HammerTrayStore, "x")-convert_in2mm(0.75))/2],
            ["rotate", [0,0, 0]],
            ["color", "LightGrey"]
        ]
    );


PegStore = 
[
    ["description", "Peg dimension properties"],
    ["x", convert_in2mm(3/8)],
    ["y", convert_in2mm(3/8)],
    ["z", convert_in2mm(2)],
    ["fragments", 60],
    // ["move", [0,kv_get(HammerBackwall, "move").y,convert_in2mm(3/8)/2]],
    ["move", [0,0,0]],
    ["from edge", (kv_get(HammerTrayStore, "x")-convert_in2mm(1))/2],
    ["rotate", [90,0, 0]],
    ["color", "LightBlue"]
];

DrillPegStore = 
[
    ["description", "Drill Peg dimension"],
    ["x", convert_in2mm(4/8)],
    ["y", convert_in2mm(4/8)],
    ["z", convert_in2mm(5)],
    ["count", 2],
    ["fragments", 60],
    ["move", [0,0,0]],
    ["from edge", (kv_get(HammerTrayStore, "x")-convert_in2mm(1))/2],
    ["rotate", [90,0, 0]],
    ["color", "LightBlue"]
];

Screw_Holes = 
[
    ["description", "screwhole dimension"],
    ["x", GRK_cabinet_screw_shank_dia],
    ["y", GRK_cabinet_screw_shank_dia],
    ["z", kv_get(TrayStore, "z")],
    ["count", 2],
    ["fragments", 60],
    ["move", [0, kv_get(BackwallStore, "y") + 1 ,convert_in2mm(2)]],
    ["rotate", [90,0, 0]],
    ["color", "red"]
];

Tool_Bit_Array = 
[
    ["description", "tool_bit_array"],
    ["x", kv_get(TrayStore, "x")],
    ["y", kv_get(TrayStore, "y")],
    ["z", kv_get(TrayStore, "z")],
    ["columns", 5],
    ["rows", 6],
    ["spacing", 0],
    ["move", [HexBitHoleDia/2, HexBitHoleDia/2, 0]],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];

ScrewDriverShaft = 
[
    ["description", "bit dimension"],
    ["x", convert_in2mm(0.5)],
    ["y", convert_in2mm(0.75)],
    ["z", kv_get(TrayStore, "z") * 1.25],
    ["fragments", 60],
    ["move", [0,0,LayersToHeight(-2)]],
    ["rotate", [0,0, 0]],
    ["color", "lightYellow"]
];


ScrewDriver_array = 
[
    ["description", "screwDriver_array"],
    ["x", kv_get(ScrewDriverShaft, "x") * 1.95],
    ["y", kv_get(ScrewDriverShaft, "y") * 1.25],
    ["z", kv_get(TrayStore, "z")*2],
    ["xCount", 4],
    ["yCount", 2],
    ["move", [kv_get(ScrewDriverShaft, "x")/2, kv_get(ScrewDriverShaft, "y")/4, 0] ],
    ["rotate", [0,0, 0]],
    ["color", "yellow"]
];


