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
Casa_Lables =
[
    "Casa lables",
    ["south", "South Wall"],
    ["east", "East Wall"],
    ["north", "North Wall"],
    ["west", "West Wall"],
];

font_lable_size = 500;
font_lable_color = "black";

//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/

module Draw_landmarks() 
{
    //north wall to house
    color( "red", 0.5) 
    translate([convert_in2mm(953 - 140.5),convert_in2mm(1284/2),0]) 
    square(size = [convert_in2mm(140.5), convert_in2mm(6)]);

    //Eech direction around the house needs landmarks.

    //East wall to house
    color( "yellow", 0.5) 
    translate([convert_in2mm(953/2),convert_in2mm(950),0]) 
    rotate([0, 0, 90])
    square(size = [convert_in2mm(341), convert_in2mm(6)]);

    //west wall to house
    color( "blue", 0.5) 
    translate([convert_in2mm(953/2 +60),convert_in2mm(12),0]) 
    rotate([0, 0, 90])
    square(size = [convert_in2mm(341), convert_in2mm(6)]);

    //south wall to house
    color( "red", 0.5) 
    translate([convert_in2mm(0),convert_in2mm(1284/1.5),0]) 
    rotate([0, 0, 0])
    square(size = [convert_in2mm(331), convert_in2mm(6)]);
}

module Draw_Lables() 
{
    color(font_lable_color, 1.0)
    translate(v = [convert_in2mm(953)/2, -convert_in2mm(36), 0]) 
    text(gdv(Casa_Lables,"east"), font_lable_size);

    color(font_lable_color, 1.0)
    translate(v = [convert_in2mm(953)/2, convert_in2mm(1284 + 36), 0]) 
    text(gdv(Casa_Lables,"west"), font_lable_size);

    color(font_lable_color, 1.0)
    translate(v = [-convert_in2mm(24), convert_in2mm(1284)/2, 0]) 
    rotate([0, 0, 90])     
    text(gdv(Casa_Lables,"south"), font_lable_size);

    color(font_lable_color, 1.0)
    translate(v = [convert_in2mm(953) + convert_in2mm(48), convert_in2mm(1284)/2, 0])  
    rotate([0, 0, 90])     
    text(gdv(Casa_Lables,"north"), font_lable_size);
}