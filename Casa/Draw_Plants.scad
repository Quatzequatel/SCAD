/*
    
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
ToolShed = [convert_in2mm(129), convert_in2mm(73)];

MadagascarPalm = 
[
    "Info",
    ["move", [ToolShed.x, ToolShed.y + convert_in2mm(36)]],
    ["z", convert_in2mm(120)],
    ["dia", convert_in2mm(20) ],
];
//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/

module Draw_Plants() 
{
    DrawMadagascarPalm();
}

module DrawMadagascarPalm() 
{
    color(c = "LightSeaGreen", 0.5) 
    translate(v = gdv(MadagascarPalm, "move")) 
    linear_extrude(height = gdv(MadagascarPalm, "z")) 
    circle(r = gdv(MadagascarPalm, "dia"));  
}