include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

build();

module build()
{
    radius = 90;

    translate([76, 46, -2])
    cylinder(r = 4, h = 4, $fn = 100);

    color("blue")
    translate([54, 4, 0])
    rotate([0, 0, -10])
    translate([radius, 0, 0])
    rotate([0, 180, 0])
    rotate([0, 0, -30])
    rotate_extrude(angle = 60, convexity = 10, $fn=100)
        translate([radius, 0, 0])
            circle(r = 2, $fn = 100);

    // translate([radius * 2, 0, 0])
    color("red")
    rotate([0, 0, -30])
    rotate_extrude(angle = 60, convexity = 10, $fn=100)
        translate([radius, 0, 0])
            circle(r = 2, $fn = 100);            
}