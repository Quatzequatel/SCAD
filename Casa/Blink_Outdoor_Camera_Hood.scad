/*
    Notes: 
    Fit is very tight. expanding from 42.7 to 43.2.
    1. Added parameter based modules
    2. Added top support for todo roof.
*/

$fn=200;
// import("C://Users//quatz//Downloads//Blink_Outdoor_Camera_Hood.stl");
build();

translate([38,0,8])
rotate([90,0,90])
linear_extrude(height = 20)
hull() {
    translate([0,32,0]) circle(7);
    circle(7);
}

module build(args) {
    draw_case(50, 47, 1);
}

module draw_case(height = 32.0, width = 47, thickness = 1 ) 
{
    r1 = 13.5;
    r2 = r1 + thickness;
    w2 = width - 3.2;

    //hole size
    hole_radius = 30;

    difference()
    {
        //main
        minkowski()
        {
            cube([width, width, 0.1], true);
            cylinder(r=r2,h=height);
        };

        //cut
        minkowski()
        {
            cube([w2, w2, 0.2], true);
            cylinder(r=r1,h=height);
        }
    }

    //bottom of case
    difference()
    {
        minkowski()
        {
            cube([47,47,0.1], true);
            cylinder(r=14.5,h=0.5);
        };

        translate([0,0,-3])
        cylinder(r=hole_radius, h=height);
    }    
}

