/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

$fn = 100; // Set the number of fragments for smoothness

Pupcile_Sphere = 
["Popcile Sphere", 
    ["x", 45],
    ["y", 45],
    ["z", 45],
    ["move", [0, 0, 0]],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"],
    ["fragments", 100]
];

Outer_Sphere = 
["Popcile Sphere", 
    ["x", 55],
    ["y", 55],
    ["z", 55],
    ["move", [0, 0, 0]],
    ["rotate", [0, 0, 0]],
    ["color", "LightGreen"],
    ["fragments", 100]
];

Wall_Width = gdv(Pupcile_Sphere, "x") + 10;

build();

module build()
{

difference()
    {
        // Draw the outer sphere first
        translate([-gdv(Outer_Sphere, "x")/2, -gdv(Outer_Sphere, "y")/2, 0])
        drawPupcileSphere(Outer_Sphere);
        
        translate([-gdv(Pupcile_Sphere, "x")/2, -gdv(Pupcile_Sphere, "y")/2, 0])
        {
            drawPupcileSphere(Pupcile_Sphere);
        }
        translate([0, 0, 30])
        cube([Wall_Width, Wall_Width, 25], center=true);

        cylinder(d=25, h=60, center=true);

        rotate([45, 0, 0])
        translate([0, 0, -20])
        minkowski()
        {
            cube([8, 3, 50], center=true);
            cylinder(r=2,h=1);
        }

        rotate([45, 0, 72])
        translate([0, 0, -20])
        minkowski()
        {
            cube([8, 3, 50], center=true);
            cylinder(r=2,h=1);
        }
                
        rotate([45, 0, 72 * 2])
        translate([0, 0, -20])
        minkowski()
        {
            cube([8, 3, 50], center=true);
            cylinder(r=2,h=1);
        }

        rotate([45, 0, 72 * 3])
        translate([0, 0, -20])
        minkowski()
        {
            cube([8, 3, 50], center=true);
            cylinder(r=2,h=1);
        }        

        rotate([45, 0, 72 * 4])
        translate([0, 0, -20])
        minkowski()
        {
            cube([8, 3, 50], center=true);
            cylinder(r=2,h=1);
        }        
    }

}



module drawPupcileSphere(properties)
{
    color(gdv(properties, "color"), 0.5)
    rotate(gdv(properties, "rotate"))
    translate(gdv(properties, "move"))
    translate([gdv(properties, "x")/2, gdv(properties, "y")/2])
    // linear_extrude(gdv(properties, "z"))
    sphere(d=gdv(properties, "x"), $fn = gdv(properties, "fragments"));
}