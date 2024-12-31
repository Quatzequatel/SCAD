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

Pool_deck = 
[
    "Deck demensions, in meters",
    ["x", M2mm(7)],
    ["y", M2mm(12)],
    ["z", 0],
    ["tx", M2mm(M = 1.5)],
    ["ty", M2mm(M = 19.5)],
];

//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/
module Draw_Pool() 
{
    DrawThePool();    
    Draw_Pool_deck();
}

module DrawThePool() 
{
    translate([gdv(Casa_pool, "tx"), gdv(Casa_pool, "ty"), 0])
    translate([0, -gdv(Casa_pool, "y"), 0])   //move so next movement is based on propery boundary.
    color("DeepSkyBlue", 1.0)
    linear_extrude(height = M2mm(0.15)) 
    square(size = [gdv(Casa_pool, "x"), gdv(Casa_pool, "y")]); 

}

module Draw_Pool_deck() 
{
    translate([gdv(Pool_deck, "tx"), gdv(Pool_deck, "ty"), 0])
    translate([0, -gdv(Pool_deck, "y"), 0])   //move so next movement is based on propery boundary.
    color("Coral", 1.0)
    square(size = [gdv(Pool_deck, "x"), gdv(Pool_deck, "y")]); 

}