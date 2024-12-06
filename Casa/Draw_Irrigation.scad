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

pipe_dia = M2mm(0.05);
manifold1Dic = 
[
    "Single manifold information",
    ["x", M2mm(0.30)],
    ["y", pipe_dia],
    ["z", pipe_dia],
    ["valve x", M2mm(0.06)],
    ["valve y", M2mm(0.06)],
    ["valve z", M2mm(0.03)],
    ["valve tx", M2mm(0.12)],
    ["valve ty", M2mm(-0.005)],
    ["valve tz", pipe_dia],
    ["solenoid dia", M2mm(0.04)],
    ["solenoid z", M2mm(0.05)],
    ["solenoid tx", M2mm(0.18)],
    ["solenoid ty", pipe_dia/2],
    ["solenoid tz", M2mm(0.08)],
    ["color1", "Aquamarine"],
    ["color2", "black"],
];

MoveManifold1=[M2mm(0.30), M2mm(24.75)];
MoveManifold2=[M2mm(9.5), M2mm(0.33)];
MoveManifold3=[convert_in2mm(949), M2mm(15)];

//-------------------------------------------------------------------------------------------------------------------
/*
    Begin Modules
*/
// Draw_Irrigation();
Draw_Irrigation();


module Draw_Irrigation() 
{
    Draw_Main_pipe() ;
    //manifold 1
    translate(v = MoveManifold1) 
    Draw_Manifold_single(manifold1Dic);
    //manifold 2
    translate(v = MoveManifold2) 
    rotate([0, 0, 90]) 
    Draw_Manifold_tri();
    //manifold 3
    translate(v = MoveManifold3) 
    rotate([0, 0, 180]) 
    Draw_Manifold_tri();
}

module Draw_Main_pipe() 
{
    //South Wall -----------------------------------------------------------------------------------------------------------
    //pipe 1
    translate([convert_in2mm(12), convert_in2mm(12)]) 
    color(gdv(pipe1Dic, "color"), 0.5)
    rotate([-90,0,0]) 
    cylinder(h = gdv(pipe1Dic, "south length"), r = gdv(pipe1Dic, "Dia"));
    
    //East Wall -----------------------------------------------------------------------------------------------------------
    //pipe 1
    translate([convert_in2mm(12), convert_in2mm(12.75)]) 
    color(gdv(pipe1Dic, "color"), 0.5)
    rotate([0,90,0]) 
    cylinder(h = gdv(pipe1Dic, "east length"), r = gdv(pipe1Dic, "Dia"));
    
    //Avoid planter wall -----------------------------------------------------------------------------------------------------------
    //pipe 1
    translate([convert_in2mm(east_wall_length + 12), convert_in2mm(12)]) 
    color(gdv(pipe1Dic, "color"), 0.5)
    linear_extrude(height = 2*gdv(pipe1Dic, "Dia")) 
    rotate(45)
    square(size = [gdv(pipe1Dic, "avoid planter length"), 2*gdv(pipe1Dic, "Dia")]);

    //North Wall -----------------------------------------------------------------------------------------------------------
    translate([convert_in2mm(948), convert_in2mm(153)]) 
    color(gdv(pipe1Dic, "color"), 0.5)
    rotate([-90,0,0]) 
    cylinder(h = gdv(pipe1Dic, "north length"), r = gdv(pipe1Dic, "Dia"));
      
}

module Draw_Manifolds() 
{

}

module Draw_Manifold_tri() 
{
    n = 3;
    mainline = [M2mm(0.32), pipe_dia];

    color(gdv(manifold1Dic, "color1"), 0.5) 
    linear_extrude(height = pipe_dia) 
    square([mainline.y, mainline.x]);

    translate([0, M2mm(0.025)]) 
    union() 
    {
        for (i = [0:n-1]) 
        {
            translate([0, M2mm(0.095) * i])       
            Draw_Manifold_single(manifold1Dic);
        }    
    }
}

module Draw_Manifold_single(dic) 
{
    union() 
    {
        //Line
        color(gdv(dic, "color1"), 0.5) 
        linear_extrude(height = gdv(dic, "z")) 
        square([gdv(dic, "x"), gdv(dic, "y")]);
        //valve
        translate([gdv(dic, "valve tx"), gdv(dic, "valve ty"), gdv(dic, "valve tz")]) 
        color(gdv(dic, "color1"), 0.5) 
        linear_extrude(height = gdv(dic, "valve z")) 
        square([gdv(dic, "valve x"), gdv(dic, "valve y")]);
        //selenoid
        translate([gdv(dic, "solenoid tx"), gdv(dic, "solenoid ty"), gdv(dic, "solenoid tz")]) 
        translate([0, 0, 0]) 
        color(gdv(dic, "color2"), 0.5) 
        linear_extrude(height = gdv(dic, "solenoid z")) 
        circle(d=gdv(dic, "solenoid dia"));
    }
}

