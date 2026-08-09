include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;

/*
    Sign has a base of ┌──┐ shape, so the anchor needs to be .
      ┌──┐
    ┌─┘  └─┐

*/

Measurements = 
[
    ["description", "lengths and dimensions for the sign flashing attachment"],
    ["flashing lip height 1", 28],              //y
    ["flashing spacing 1", 275/2 - 57/2],       //x
    ["base height", 31],                        //y
    ["base width", 57],                         //x
    ["flashing lip height 2", 10],              //y
    ["flashing spacing 2", 275/2 - 57/2],       //x
    ["anchor thickness", 2],
    ["anchor width", 26]
];

polygon_points = 
[
    ["description", "dimension properties drawn object"],
    ["point0", [0,0]],
    ["point1", [0,
                kv_get(Measurements, "flashing lip height 1")]],

    ["point2", [kv_get(Measurements, "flashing spacing 1"),
                kv_get(Measurements, "flashing lip height 1")]],

    ["point3", [kv_get(Measurements, "flashing spacing 1"),
                kv_get(Measurements, "flashing lip height 1") 
                    + kv_get(Measurements, "base height")]],

    ["point4", [kv_get(Measurements, "flashing spacing 1") 
                    + kv_get(Measurements, "base width"),
                kv_get(Measurements, "flashing lip height 1") 
                    + kv_get(Measurements, "base height")]],

    ["point5", [kv_get(Measurements, "flashing spacing 1") 
                    + kv_get(Measurements, "base width"),
                kv_get(Measurements, "flashing lip height 1")]],
                
    ["point6", [kv_get(Measurements, "flashing spacing 1") 
                    + kv_get(Measurements, "base width") 
                    + kv_get(Measurements, "flashing spacing 2"),
                kv_get(Measurements, "flashing lip height 1")]],
    ["point7", [kv_get(Measurements, "flashing spacing 1") 
                    + kv_get(Measurements, "base width") 
                    + kv_get(Measurements, "flashing spacing 2"),
                0]]
];

build(args = []);

module build(args = []) 
{
    $fn = 100;
    width = kv_get(Measurements, "anchor width");
    thickness = kv_get(Measurements, "anchor thickness");
    points = 
    [
        kv_get(polygon_points, "point0"),
        kv_get(polygon_points, "point1"),
        kv_get(polygon_points, "point2"),
        kv_get(polygon_points, "point3"),
        kv_get(polygon_points, "point4"),
        kv_get(polygon_points, "point5"),
        kv_get(polygon_points, "point6"),
        kv_get(polygon_points, "point7")
    ];

difference()
    {
        union()
        {
            linear_extrude(height = width)
            {
                difference()
                {
                    offset(r = thickness) polygon(points);
                    polygon(points);
                }
            }        
        }

        #translate([0, -thickness, 0])
        linear_extrude(height = width)        
        square([kv_get(Measurements, "flashing spacing 1") 
                    + kv_get(Measurements, "base width") 
                    + kv_get(Measurements, "flashing spacing 2"),
                thickness], center=false);        
    }




}