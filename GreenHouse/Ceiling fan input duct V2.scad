/*
    
*/

include <constants.scad>;
// include <..\DownSpout\DownSpoutToPipeAttachment.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
$fn= 100;

walls = 3;
fan = 
[
    "",
        ["width", 120],    //x
        ["depth", WallThickness(walls)],      //y
        ["height", 120],   //z 
        ["orientation", [90,0,0]]
];

fan_input =
[
    "",
        ["radius", 60],
        ["angle", 90],
        ["length1", 0],
        ["length2", 60],
        ["wallThickness", WallThickness(walls)],
        ["screw diameter", 10],
        ["screw length", gdv(fan, "depth") + 6 + WallThickness(walls + 2)],
        ["screw hole length", 105]     ,
        ["fan length", gdv(fan, "width")]
];

function f_screw_hole_length() = (gdv(fan_input, "fan length") - gdv(fan_input, "screw hole length"))/2;

function f_screw_hole_location(i) = 
    i == 0 ? gdv(fan_screw_hole_locations, "hole1") :
    i == 1 ? gdv(fan_screw_hole_locations, "hole2")
    : 0;

fan_screw_hole_locations =
[
    "",
    ["hole1", [f_screw_hole_length(), 5, gdv(fan_input, "fan length")/2 - f_screw_hole_length()]],
    ["hole2", [gdv(fan_input, "fan length")- f_screw_hole_length(), 5, gdv(fan_input, "fan length")/2 - f_screw_hole_length()]]
];


build();

module build(args) 
{

    rotate([90,0,0])
    make_fan_input();
}

module make_fan()
{
    translate([gdv(fan, "width")/2, gdv(fan, "depth"), 0])
    rotate(gdv(fan, "orientation"))
    linear_extrude(gdv(fan, "depth"))
    square( size = [gdv(fan, "width"), gdv(fan, "height")], center=true);
}

module make_fan_input()
{
    difference()
    {
        union()
        {
            make_fan();

            translate([0, convert_in2mm(1.5), 0])
            translate([gdv(fan_input, "radius"), gdv(fan_input, "wallThickness"), 0])
            rotate(gdv(fan, "orientation"))
            Tube(
                od = 2 * gdv(fan_input, "radius"), 
                id = 2 * gdv(fan_input, "radius") - (2 * gdv(fan_input, "wallThickness")), 
                length = convert_in2mm(1.5)
                );
        }
        

        translate([gdv(fan_input, "radius"), gdv(fan_input, "wallThickness"), 0])
        rotate(gdv(fan, "orientation"))
        cylinder(r=gdv(fan_input, "radius")- gdv(fan_input, "wallThickness"), h= gdv(fan_input, "wallThickness") + 1);



        // translate(f_screw_hole_location(0))
        // make_screw_holes();
        
        // translate(f_screw_hole_location(1))
        // make_screw_holes();

    }
    
    // elbowPipe(
    //         radius = gdv(fan_input, "radius"), 
    //         length1 = gdv(fan_input, "length1"), 
    //         length2 = gdv(fan_input, "length2"), 
    //         angle = gdv(fan_input, "angle"), 
    //         wallThickness = gdv(fan_input, "wallThickness")
    //         );
}

module Thing()
{
    // elbowPipe(radius = 60, length = 0, angle = 90, wallThickness = WallThickness(4));
    elbowPipe(
            radius = gdv(fan_input, "radius"), 
            length1 = gdv(fan_input, "length1"), 
            length2 = gdv(fan_input, "length2"), 
            angle = gdv(fan_input, "angle"), 
            wallThickness = gdv(fan_input, "wallThickness")
        );

    // elbow(radius = 60, length1 = 0, length2 = 120, angle = 90);
}

module elbow(radius, length1, length2, angle)
{
    translate([-length2,radius])
    rotate([0,90,0]) 
    cylinder(r=radius, h = length2, $fn=100);
    
    rotate_extrude(angle=angle, convexity=10, $fn=100)
    translate([radius,0])
    circle(radius);
    
    translate([radius,0])
    rotate([90,0,0]) 
    cylinder(r=radius, h = length1, $fn=100);
}


module elbowPipe(radius, length1, length2, angle, wallThickness)
{
    difference()
    {
        elbow(radius,length1, length2,angle);
        
        translate([wallThickness,wallThickness])
        elbow(radius-wallThickness, length1+wallThickness+1, length2+wallThickness+1, angle);
    }
}

module Tube(od, id, length)
{
    linear_extrude(height=length)
    {
        difference()
        {
            circle(r=od/2);
            circle(r=id/2);
        }
    }
}

// module pipe(radius, length, wallThickness)
// {
//     echo(radius = radius, length = length, wallThickness = wallThickness);
//     difference()
//     {
//         cylinder(radius*2, length);
//         cylinder(radius - wallThickness, length + wallThickness);
//     }
// }

module make_screw_holes()
{
    # screw_hole(diameter = gdv(fan_input, "screw length"), length=gdv(fan_input, "screw length") );
}

module screw_hole(diameter, length)
{
        rotate([90,0,0])
        linear_extrude(length)
        circle(d=diameter);
}