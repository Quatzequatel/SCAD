/*
    Module for drawing Carport.
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
Carport_points = [
    [0,0],
    [0, convert_in2mm(298)],
    [convert_in2mm(171), convert_in2mm(298)],
    [convert_in2mm(171), 0],
];

//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/

module Draw_Carport() 
{
    //this is the carport
    translate([convert_in2mm(61), M2mm(32.75) - convert_in2mm(298),0]) 
    linear_extrude(height = convert_in2mm(8)) 
    polygon(Carport_points);

    //driveway needs to verified and corrected.
    translate([M2mm(16), M2mm(26.75) - convert_in2mm(240),0]) 
    linear_extrude(height = convert_in2mm(8)) 
    square(size = [convert_in2mm(120), convert_in2mm(341) + M2mm(3.50)]);
}