/*
    holder to support cpu fan inside cinder block hole.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
$fn = 100;

fan = 
[
    "",
        ["width", 120],    //x
        ["depth", 25],      //y
        ["height", 120],   //z 
        ["orientation", [90,0,0]]
];

holder = 
[
    "",
        ["width", 25],  //x  
        ["depth", 75],  //y
        ["height", 12], //z2  
        ["radius", 6],
        ["orientation", [0,0,90]],
        ["base height", 3] //z1
];

build();

module build(args) 
{
    CPU_Fan_holder();
}

module CPU_Fan_holder()
{
    difference()
    {
        make_holder();
        translate([0,0, gdv(holder, "base height")])
        make_fan();
    }
}

module make_fan()
{
    translate([-gdv(fan, "width")/2, gdv(fan, "depth")/2, 0])
    rotate(gdv(fan, "orientation"))
    linear_extrude(gdv(fan, "depth"))
    square( size = [gdv(fan, "width"), gdv(fan, "height")], center=false);
}

module make_holder()
{
    translate([0, 0, gdv(holder, "height")])
    rotate([0, 180, 0])
    linear_extrude(height = gdv(holder, "height"),  convexity = 10, scale = [1.1, 6])
    circle(r = gdv(holder, "radius"));
    
}