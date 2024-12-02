/*
    Main drawing module.
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
Casa = 
[
    "Casa Infromation",
    ["first floor height", M2mm(3.04)],
];



Floor_points = [
    [M2mm(6.10), M2mm(0)],     //0
    [M2mm(11.95), M2mm(0)],     //1
    [M2mm(11.95), M2mm(4.27)],     //2
    [M2mm(9.22), M2mm(4.27)],     //3
    [M2mm(9.22), M2mm(7.17)],     //4
    [M2mm(7.39), M2mm(7.17)],     //5
    [M2mm(7.39), M2mm(10.54)],     //6
    [M2mm(8.45), M2mm(10.54)],     //7
    [M2mm(8.45), M2mm(13.72)],     //8
    [M2mm(0), M2mm(13.72)],     //9
    [M2mm(0), M2mm(3.05)],     //10
    [M2mm(6.10), M2mm(3.05)],     //11
    [M2mm(6.10), M2mm(0)],     //12
];

Floor_Center = [-M2mm(11.95)/2, -M2mm(13.72)/2];



//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/
module Draw_Casa()
{
    Draw_Casa_Perrimeter();
}

module Draw_Casa_Perrimeter() 
{
    translate([M2mm(14.5), M2mm(17), 0]) 
    linear_extrude(height = gdv(Casa, "first floor height")) 

    // mirror([1,0,0])
    rotate([0, 0, 180]) 
    translate(Floor_Center) 
    difference()
    {
        polygon(Floor_points);
        offset(delta= convert_in2mm(-8)) polygon(Floor_points);
    }
}