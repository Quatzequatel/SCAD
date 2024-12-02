/*
    Modules for the walls.
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
Casa_Walls = 
[
    "Casa Wall information",
    ["x", convert_ft2mm(61)],
    ["y", convert_ft2mm(26)],
    ["z", convert_ft2mm(4)],
    ["wall width", convert_in2mm(8)],
    ["south wall", convert_in2mm(1284)],
    ["east wall", convert_in2mm(953)],
    ["north wall", convert_in2mm(1284)],
    ["west wall", convert_in2mm(953)],
    ["rotate",[0,0,0]],
    //["move",[convert_ft2mm(15), convert_ft2mm(25), convert_ft2mm(firstFlorLabels_ft)]],
    ["color", "Khaki"]
];

Wall_points = [
    [0,0],
    [0,convert_in2mm(1284)],
    [convert_in2mm(953),convert_in2mm(1284)],
    [convert_in2mm(953),0]
];

//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/
module Draw_Walls()
{
    linear_extrude(height = gdv(Casa_Walls, "z")) 
    difference()
    {
        offset(delta= convert_in2mm(8)) polygon(Wall_points);
        polygon(Wall_points);
    }    
}

