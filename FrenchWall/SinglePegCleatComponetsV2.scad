include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;
use <../FrenchWall/BitTool_holder.scad>;
use <../FrenchWall/SinglePegCleatProperties.scad>;
use <kvpairs.scad>;

use <convert.scad>;

PegStore = 
    [
        ["description", "PegStore"],
        ["x", convert_in2mm(3/8)],
        ["y", convert_in2mm(3/8)],
        ["z", convert_in2mm(2)],
        ["fragments", 60],
        ["move", [0,kv_get(HammerBackwall, "move").y,convert_in2mm(3/8)/2]],
        ["from edge", (kv_get(HammerTray, "x")-convert_in2mm(1))/2],
        ["rotate", [90,0, 0]],
        ["color", "LightBlue"]
    ];

TrayStore = ["description", "TrayStore", 
        ["x", convert_in2mm(2/8)],
        ["y", convert_in2mm(2/8)],
        ["z", convert_in2mm(0.75)],
        ["move", [0, 0, 0]],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
];

CleatStore = ["description", "CleatStore",
        ["x", kv_get(TrayStore, "x")],
        ["y", cleat_thickness],
        ["z", convert_in2mm(0.75)],
        ["parallelogram length", convert_in2mm(0.75)/sin(45) ],
        ["parallelogram thickness", cleat_thickness],
        ["angle", 135],
        ["extrude height", gdv(Tray(), "x")],
        ["move", [0, 0, 0]],
        ["from edge", 0],
        ["rotate", [0,0, 0]],
        ["color", "LightGrey"]
];

BackwallStore = [
    ["description", "BackwallStore"],
    ["x", convert_in2mm(2)],
    ["y", kv_get(CleatStore, "y")],
    ["z", convert_in2mm(3)],
    ["from edge", 0],
    ["cleat", CleatStore],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

// echo("Single Peg Cleat Components Properties:");
echo("PegStore = PegStore");
debugEcho("PegStore", PegStore, true);
PegStore2 = kv_set(PegStore, "description", "PegStore2");
echo();
debugEcho("PegStore", PegStore2, true);
// PegStore3 = kv_set(PegStore2, "description", "PegStore3");
PegStore3 = kv_merge(PegStore2, [["x", 10], ["y", 10], ["z", 10]]);
echo();
debugEcho("PegStore", PegStore3, true);

draw_single_peg_cleat_hook(); 

module draw_single_peg_cleat_hook(pegLengthInches = 1, pegRadiusInches = 3/8, hull = false)
{
    echo();
    echo(FileName = str(pegLengthInches, "_in_single_peg_cleat.stl"));
    echo();

    pegRadius = convert_in2mm(pegRadiusInches);
    pegAdjStore = kv_merge(PegStore, 
        [
            ["description", str(pegLengthInches, " in_single_peg")], 
            ["x", pegRadius], 
            ["y", pegRadius], 
            ["z", convert_in2mm(pegLengthInches)]
        ]);    

    backwallAdjStore = kv_merge(BackwallStore, 
        [
            ["description", "BackwallAdjStore"],
            ["filename", "BackwallAdjStore.stl"]
        ]
    );

    // applyRotate(pegAdjStore)
    // applyExtrude(pegAdjStore)
    moveToOrigin(pegAdjStore)
    drawCircleShape2(pegAdjStore);

    translate([ kv_get(TrayStore, "x"), -3, kv_get(TrayStore, "x")])
    rotate([180, 180, -5 ])
    draw_Cleated_Back_Wall(backwallAdjStore);  
}