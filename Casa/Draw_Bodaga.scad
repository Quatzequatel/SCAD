/*
    Note:
        X = is horizontal which is also in the North-South vector.
        Y = is vertical in the East-West Vector.    
*/

include <constants.scad>;
include <Casa_globals.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

//-------------------------------------------------------------------------------------------------------------------
/*
    Local verables
*/
PumpHouseDic = 
[
    "Pump House information",
    ["x", convert_in2mm(61)],
    ["y", convert_in2mm(60)],
    ["z", convert_in2mm(60)],
    ["Wall", convert_in2mm(7)],
    ["rotate",[0,0,0]],
    // ["move",[convert_ft2mm(15), gdv(PropertyDic, "y"), 0]],
    ["color", "Khaki"]
];

PumpHouseDic_move = [convert_in2mm(4), gdv(PropertyDic, "y") - 2*gdv(PumpHouseDic, "y"), 0];

ToolShedDic = 
[
    "Tool shed information",
    ["x", convert_in2mm(129)],
    ["y", convert_in2mm(73)],
    ["z", convert_in2mm(94)],
    ["wall", convert_in2mm(7)],
    ["rotate",[0,0,0]],
    // ["move",[convert_ft2mm(15), gdv(PropertyDic, "y"), 0]],
    ["color", "Khaki"]
];

ToolShedDic_move = [0, 0, 0];
ToolShedDic_offset = [gdv(ToolShedDic, "x") - 2*gdv(ToolShedDic, "wall"), 
                        gdv(ToolShedDic, "y") - 2*gdv(ToolShedDic, "wall")];

CompostBlind = 
[
    "Pump House information",
    ["x", M2mm(1)],
    ["y", M2mm(2)],
    ["z", M2mm(1.6)],
    ["wall", convert_in2mm(1)],
    ["rotate",[0,0,0]],
    // ["move",[convert_ft2mm(15), gdv(PropertyDic, "y"), 0]],
    ["color", "DarkGoldenrod"]
];

CompostBlind_move = [M2mm(0), M2mm(1.8), 0];
CompostBlind_offset = [gdv(CompostBlind, "x") - gdv(CompostBlind, "wall"), 
                        gdv(CompostBlind, "y") - gdv(CompostBlind, "wall")];

//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/

Draw_Bodaga();

module Draw_Bodaga() 
{
    //Draw Pump House.
    color(gdv(PumpHouseDic, "color"), 0.25)
    translate(PumpHouseDic_move)
    linear_extrude(gdv(PumpHouseDic, "z"))
    square(size=[gdv(PumpHouseDic, "x"), gdv(PumpHouseDic, "y")], center=false);

    //Draw Toolshed.
    color(gdv(ToolShedDic, "color"), 0.25)
    translate(ToolShedDic_move)
    linear_extrude(gdv(ToolShedDic, "z"))
    difference() 
    {
        square(size=[gdv(ToolShedDic, "x"), gdv(ToolShedDic, "y")], center=false);

        translate(v = [gdv(ToolShedDic, "wall"), gdv(ToolShedDic, "wall")]) 
        square(ToolShedDic_offset, center=false);
    }
    

    //Draw Compost Blind
    color(gdv(CompostBlind, "color"), 0.25)
    translate(CompostBlind_move)
    linear_extrude(gdv(CompostBlind, "z"))
    difference() 
    {
        square(size=[gdv(CompostBlind, "x"), gdv(CompostBlind, "y")], center=false);
        translate(v = [-gdv(CompostBlind, "wall"), -gdv(CompostBlind, "wall")]) 
        square(CompostBlind_offset, center=false);
    }
    
}

//-----------------------------------------------------
// Utilities Below
//-----------------------------------------------------
module drawSquareShape(dictionary)
{
    //This should work but it does not.

    // echo(y = gdv(dictionary, "y"));
    // properties_echo(dictionary);
    color(gdv(dictionary, "color"), 0.5)
    rotate(gdv(dictionary, "rotate"))
    translate(gdv(dictionary, "move"))
    //move to xy location
    // translate([gdv(dictionary, "x")/2, gdv(dictionary, "y")/2])
    linear_extrude(gdv(dictionary, "z"))
    square(size=[gdv(dictionary, "x"), gdv(dictionary, "y")], center=true);
}
