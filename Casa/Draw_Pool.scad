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
Casa_pool = 
[
    "pool demensions, in meters",
    ["x", M2mm(3.5)],
    ["y", M2mm(7.5)],
    ["z", 0],
    ["tx", M2mm(M = 3.0)],
    ["ty", M2mm(M = 16.5)],
];

//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/
module Draw_Pool() 
{
    
    translate([gdv(Casa_pool, "tx"), gdv(Casa_pool, "ty"), 0])
    translate([0, -gdv(Casa_pool, "y"), 0])   //move so next movement is based on propery boundary.
    color("SteelBlue", 1.0)
    square(size = [gdv(Casa_pool, "x"), gdv(Casa_pool, "y")]); 
}