/*
This is a bracket to attach CPU fan to the roof peak.
*/

include <constants.scad>;
// include <CPU fan insert holder.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

$fn = 100;

// wall_thickness = WallThickness(3);
walls = 6;

fan = 
[
    "",
        ["width", 122],    //x
        ["depth", 27],      //y
        ["height", 122],   //z 
        ["orientation", [90,0,0]]
];

bracket = 
[
    "",
        ["width", gdv(fan, "width") + WallThickness(walls)],    //x
        ["depth", gdv(fan, "depth") + WallThickness(walls)],      //y
        ["height", gdv(fan, "height") / 4],   //z 
        ["orientation", [90,0,0]],
        ["screw diameter", 10],
        ["screw length", gdv(fan, "depth") + 6 + WallThickness(walls + 2)]
];

build();

module build(args) 
{
    echo( bracket = bracket);

     difference()
     {
        union()
        {
            make_bar_attachment();
            make_left_fan_bracket();
            make_right_fan_bracket();         
        }     

        translate([0,0,WallThickness(walls)])
        make_fan();     
        #make_right_screw_hole();     
        #make_left_screw_hole();  
     }
}

module make_fan()
{
    translate([-gdv(fan, "width")/2, gdv(fan, "depth")/2, 0])
    rotate(gdv(fan, "orientation"))
    linear_extrude(gdv(fan, "depth"))
    square( size = [gdv(fan, "width"), gdv(fan, "height")], center=false);
}

module make_left_fan_bracket()
{
    points = getTrianglePoints(sideA = gdv(bracket, "height"), angleA = 45);
    // echo(points = points);
    translate([-gdv(bracket, "width")/2, 0, 0])
    translate([0, gdv(bracket, "depth")/2, 0]) // move to center
    rotate([90,0,0]) //flip
    linear_extrude(gdv(bracket, "depth"))
    polygon(points=points);
}

module make_right_fan_bracket()
{
    points = getTrianglePoints(sideA = -gdv(bracket, "height"), angleA = 45);
    // echo(points = points);
    translate([gdv(bracket, "width")/2, 0, 0])
    translate([0, -gdv(bracket, "depth")/2, 0]) // move to center
    rotate([-90,0,0]) //flip
    linear_extrude(gdv(bracket, "depth"))
    polygon(points=points);
}

module make_bar_attachment()
{
    linear_extrude(WallThickness(walls))
    square( size = [gdv(bracket, "width"), gdv(bracket, "depth")], center = true);
}

module make_right_screw_hole()
{
    translate([gdv(fan, "width")/2 - 7.5 ,0 , 7.5])
    translate([0 ,0 , gdv(bracket, "screw diameter")/2])
    rotate([90,0,0])
    translate([0, 0, - gdv(bracket, "screw length") / 2]) 
    // rotate([90,0,0])
    linear_extrude(gdv(bracket, "screw length"))
        circle(d=gdv(bracket, "screw diameter")/2);
}

module make_left_screw_hole()
{
    translate([(gdv(fan, "width")/2 - 7.5) * -1 ,0 , 7.5])
    translate([0 ,0 , gdv(bracket, "screw diameter")/2])
    rotate([90,0,0])
    translate([0, 0, - gdv(bracket, "screw length") / 2]) 
    // rotate([90,0,0])
    linear_extrude(gdv(bracket, "screw length"))
        circle(d=gdv(bracket, "screw diameter")/2);
}