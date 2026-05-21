include <constants.scad>;

use <kvpairs.scad>;
use <convert.scad>;

SimpleOpenTopBox =  
[
    ["description", "dimension properties for simple open top box"],
    ["x", convert_in2mm(2)], // length of box in x direction
    ["y", convert_in2mm(2)], // length of box in y direction
    ["z", convert_in2mm(1)], // height of box
    ["wall thickness", 2.5],
    ["move", [0, 0, 0]],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"] 
];

echo(SimpleOpenTopBox = SimpleOpenTopBox);
Draw_SimpleOpenTopBox(SimpleOpenTopBox);    
/*
    width properties are on the x-axis and depth properties are on the y-axis.
*/
module Draw_SimpleOpenTopBox(properties = SimpleOpenTopBox)
{
    wall_thickness = kv_get(properties, "wall thickness");

    // create box with walls on the outside of the dimensions and then move it to origin. 
    difference()
    {
        cube([kv_get(properties, "x"), kv_get(properties, "y"), kv_get(properties, "z")], center = false);
        translate([wall_thickness, wall_thickness, wall_thickness])
        cube([kv_get(properties, "x")-2*wall_thickness, kv_get(properties, "y")-2*wall_thickness, kv_get(properties, "z")], center = false);
    }
}
