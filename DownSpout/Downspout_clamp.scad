/*
    
*/
$fn = 100;
include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <morphology.scad>;

Downspourt_Strap_depth = convert_in2mm(1);
Downspourt_Strap_width = convert_in2mm(2);
Downspourt_HEIGHT = 63; //orginal value = 42.2;
Downspourt_WIDTH = 85; //orginal value = 64.2;
thickness = 3;

build();

module build(args) 
{
    difference()
    {
        linear_extrude(Downspourt_Strap_depth)    Thing();

        translate([Downspourt_WIDTH + Downspourt_Strap_width/2, 0, Downspourt_Strap_depth/2])
        rotate([90, 0, 0]) 
        #cylinder(r=2, h=20, center=true);
    }
}

module Thing()
{
    // shell(-3) square(size=[Downspourt_HEIGHT, Downspourt_WIDTH], center=true);
    difference()
    {
        shell(3) 
        union()
        {
            square(size=[Downspourt_WIDTH, Downspourt_HEIGHT], center=false);
            translate([Downspourt_WIDTH-1,0,0])
            square(size=[Downspourt_Strap_width, thickness], center=false);
        }  
        
        translate([Downspourt_WIDTH+thickness,0,0])
        square(size=[Downspourt_Strap_width, thickness], center=false);
    }    
}