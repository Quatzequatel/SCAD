/*
    
*/
$fn = 100;
include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

build();

module build(args) 
{
    lable_angle(a = 42);
}

module lable_angle(a = 30, l = 40, r = 1, size = 9, color = "blue") 
{
    color(color) 
    union()
    {
        rotate_extrude(angle = a, $fn=100)
        translate([l, 0])
        circle(r = r, $fn=100);

        square([l,1]);

        rotate([0,0,a])
        square([l,1]);

        rotate([0,0,a/2])
        translate([l/3, -l/size])
        text(text = str(a, "°"), size = size);
    }
}    

