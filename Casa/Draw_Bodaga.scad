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


//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/

Draw_Bodaga();

module Draw_Bodaga() 
{
//    drawSquareShape(PumpHouseDic);
    color(gdv(PumpHouseDic, "color"), 0.5)
    translate(PumpHouseDic_move)
    linear_extrude(gdv(PumpHouseDic, "z"))
    square(size=[gdv(PumpHouseDic, "x"), gdv(PumpHouseDic, "y")], center=false);
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
