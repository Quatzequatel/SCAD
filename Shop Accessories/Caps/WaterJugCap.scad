/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

//Globals
$fn = 100;
// ID = 44.4; This is actual.
ID = 46.5; // with thread
Thickness = 4;
Height = 8.7 + Thickness;

Hose_OD = 10.2; //this is actual.

build();

module build(args) 
{
    WaterJugCap();
}

module WaterJugCap()
{
    echo();
    echo("Save As, WaterJugCap.stl");
    echo();

    difference()
    {
        linear_extrude(height = Height)
        circle(d= ID + Thickness);    

        translate([0, 0, Thickness])
        linear_extrude(height = Height)
        circle(d= ID);   
        
        translate([0, 0, -Thickness])
        linear_extrude(height = Height)
        circle(d=Hose_OD); 
    }
    
}