include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;
/********
    properties for single peg cleat hook
    peg is 3/8" x 3/8" x 2"
    tray is 2/8" x 2/8" x 0.75"
    cleat thickness is 1/8"
    cleat angle is 135 degrees
*/

function Peg(args) =     
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

function PegAdjusted(X,Y,Z,fragments,move,from_edge,rotate,color) = 
    ["Peg dimension",
        ["x", X],
        ["y", Y],
        ["z", Z],
        ["fragments", fragments],
        ["move", move],
        ["from edge", from_edge],
        ["rotate", rotate],
        ["color", color]
    ];

function Tray(args) = 
    ["tray", 
        ["x", convert_in2mm(2/8)],
        ["y", convert_in2mm(2/8)],
        ["z", convert_in2mm(0.75)],
        ["move", [0, 0, 0]],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
    ];

function TrayAdjusted(X,Y,Z,move,rotate,color) = 
    ["tray", 
        ["x", X],
        ["y", Y],
        ["z", Z],
        ["move", move],
        ["rotate", rotate],
        ["color", color]
    ];

function Cleat(args) = 
    ["cleat properties", 
        ["x", gdv(Tray(), "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(0.75)],
        ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
        ["parallelogram thickness", cleat_thickness],
        ["angle", 135],
        ["extrude height", gdv(Tray(), "x")],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0, 0, 0]],
        ["color", "LightGrey"]
    ];

function CleatAdjusted(X,Y,Z,parallelogram_length,parallelogram_thickness,angle,extrude_height,move,from_edge,rotate,color) = 
    ["cleat properties", 
        ["x", X],
        ["y", Y],
        ["z", Z],
        ["parallelogram length", parallelogram_length],
        ["parallelogram thickness", parallelogram_thickness],
        ["angle", angle],
        ["extrude height", extrude_height],
        ["move", move],
        ["from edge", from_edge],
        ["rotate", rotate],
        ["color", color]
    ];  

function Backwall(args) = 
    ["backwall", 
        ["filename", "Cleat_for_wall.stl"],
        ["x", gdv(Tray(), "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(2.5)],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["include cleat", false],
        ["cleat", Cleat()],
        ["color", "LightGrey"]
    ];

function BackwallAdjusted(filename,X,Y,Z,move,from_edge,rotate,include_cleat,cleat,color) = 
    ["backwall", 
        ["filename", filename],
        ["x", X],
        ["y", Y],
        ["z", Z],
        ["move", move],
        ["from edge", from_edge],
        ["rotate", rotate],
        ["include cleat", include_cleat],
        ["cleat", cleat],
        ["color", color]
    ];  
    