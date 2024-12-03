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
south_wall_length = 1152;
east_wall_length = 795;
north_wall_length = south_wall_length -25;
avoid_planter_length = 200;

pipe1Dic = 
[
    "Pipe information",
    ["south length", convert_in2mm(south_wall_length)],
    ["east length", convert_in2mm(east_wall_length)],
    ["north length", convert_in2mm(north_wall_length)],
    ["avoid planter length", convert_in2mm(avoid_planter_length)],
    ["Dia", convert_in2mm(0.75)],
    ["color", "red"],
];

pipe2Dic = 
[
    "Pipe information",
    ["south length", convert_in2mm(south_wall_length) - convert_in2mm(3)],
    ["east length", convert_in2mm(east_wall_length) - convert_in2mm(6)],
    ["north length", convert_in2mm(north_wall_length) - convert_in2mm(6)],
    ["avoid planter length", convert_in2mm(avoid_planter_length)],
    ["Dia", convert_in2mm(0.75)],
    ["color", "blue"],
];

pipe3Dic = 
[
    "Pipe information",
    ["south length", convert_in2mm(south_wall_length) - convert_in2mm(6)],
    ["east length", convert_in2mm(east_wall_length) - convert_in2mm(12)],
    ["north length", convert_in2mm(north_wall_length) - convert_in2mm(10)],
    ["avoid planter length", convert_in2mm(avoid_planter_length)],
    ["Dia", convert_in2mm(0.75)],
    ["color", "orange"],
];

//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/
Draw_Irrigation();

module Draw_Irrigation() 
{
    //South Wall -----------------------------------------------------------------------------------------------------------
    //pipe 1
    translate([convert_in2mm(12), convert_in2mm(12)]) 
    color(gdv(pipe1Dic, "color"), 0.5)
    rotate([-90,0,0]) 
    cylinder(h = gdv(pipe1Dic, "south length"), r = gdv(pipe1Dic, "Dia"));
    
    //pipe 2
    translate([convert_in2mm(12+3), convert_in2mm(12+3)]) 
    color(gdv(pipe2Dic, "color"), 0.5)
    rotate([-90,0,0]) 
    cylinder(h = gdv(pipe2Dic, "south length"), r = gdv(pipe2Dic, "Dia"));
    
    //pipe 3
    translate([convert_in2mm(12+6), convert_in2mm(12+6)]) 
    color(gdv(pipe3Dic, "color"), 0.5)
    rotate([-90,0,0]) 
    cylinder(h = gdv(pipe3Dic, "south length"), r = gdv(pipe3Dic, "Dia"));

    //East Wall -----------------------------------------------------------------------------------------------------------
    //pipe 1
    translate([convert_in2mm(12), convert_in2mm(12.75)]) 
    color(gdv(pipe1Dic, "color"), 0.5)
    rotate([0,90,0]) 
    cylinder(h = gdv(pipe1Dic, "east length"), r = gdv(pipe1Dic, "Dia"));
    
    //pipe 2
    translate([convert_in2mm(12+3), convert_in2mm(12.75+3)]) 
    color(gdv(pipe2Dic, "color"), 0.5)
    rotate([0,90,0]) 
    cylinder(h = gdv(pipe2Dic, "east length"), r = gdv(pipe2Dic, "Dia"));
    
    //pipe 3
    translate([convert_in2mm(12+6), convert_in2mm(12.75+6)]) 
    color(gdv(pipe3Dic, "color"), 0.5)
    rotate([0,90,0]) 
    cylinder(h = gdv(pipe3Dic, "east length"), r = gdv(pipe3Dic, "Dia"));

    //Avoid planter wall -----------------------------------------------------------------------------------------------------------
    //pipe 1
    translate([convert_in2mm(east_wall_length + 12), convert_in2mm(12)]) 
    color(gdv(pipe1Dic, "color"), 0.5)
    linear_extrude(height = 2*gdv(pipe1Dic, "Dia")) 
    rotate(45)
    square(size = [gdv(pipe1Dic, "avoid planter length"), 2*gdv(pipe1Dic, "Dia")]);

    //pipe 2
    translate([convert_in2mm(east_wall_length + 9), convert_in2mm(15.5)]) 
    color(gdv(pipe2Dic, "color"), 0.5)
    linear_extrude(height = 2*gdv(pipe2Dic, "Dia")) 
    rotate(45)
    square(size = [gdv(pipe2Dic, "avoid planter length"), 2*gdv(pipe2Dic, "Dia")]);

    //pipe 3
    translate([convert_in2mm(east_wall_length + 6), convert_in2mm(18)]) 
    color(gdv(pipe3Dic, "color"), 0.5)
    linear_extrude(height = 2*gdv(pipe3Dic, "Dia")) 
    rotate(45)
    square(size = [gdv(pipe3Dic, "avoid planter length"), 2*gdv(pipe3Dic, "Dia")]);

    //North Wall -----------------------------------------------------------------------------------------------------------
    translate([convert_in2mm(948), convert_in2mm(153)]) 
    color(gdv(pipe1Dic, "color"), 0.5)
    rotate([-90,0,0]) 
    cylinder(h = gdv(pipe1Dic, "north length"), r = gdv(pipe1Dic, "Dia"));
    
    //pipe 2
    translate([convert_in2mm(945), convert_in2mm(157)]) 
    color(gdv(pipe2Dic, "color"), 0.5)
    rotate([-90,0,0]) 
    cylinder(h = gdv(pipe2Dic, "north length"), r = gdv(pipe2Dic, "Dia"));
    
    //pipe 3
    translate([convert_in2mm(941.5), convert_in2mm(159)]) 
    color(gdv(pipe3Dic, "color"), 0.5)
    rotate([-90,0,0]) 
    cylinder(h = gdv(pipe3Dic, "north length"), r = gdv(pipe3Dic, "Dia"));
    //-------------------------------------------------------------------------------------------------------------------
}