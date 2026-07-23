include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;

polygon_points3 = 
[
    ["description", "dimension properties drawn object"],
    ["thickness", 3],
    ["lip", 8],
    ["x1", 60],
    ["x2", 0],
    ["y1", 46.5],
    ["y2", 0],
    ["y3", 120]
];
// set the x2 and y2 values based on x1, y1, and thickness
polygon_points2 = kv_set(polygon_points3, "x2", kv_get(polygon_points3, "x1") + kv_get(polygon_points3, "thickness"));
polygon_points = kv_set(polygon_points3, "y2", kv_get(polygon_points3, "y1") + kv_get(polygon_points3, "thickness"));

Screwholes = 
[   
    ["description", "dimension properties for tool tray"],
    ["x", 65],
    ["y", 0],
    ["z", 95],
    ["screw hole diameter", 3.86],
    ["screw hole fn", 100],
    ["screw hole depth", 10],
    ["screw hole countersink diameter", 7.01],
    ["screw hole countersink fn", 100],
    ["screw hole countersink depth", 1.89],
    ["move", [40, 17, 17]],
    ["move countersink", [kv_get(polygon_points, "x1") + 0.9, 17, 17]],
    ["move screw driver", [0, 17, 17]],
    ["rotate", [0, 90, 0]],
    ["color", "LightGrey"]
];

drawScrewHoles();
// build(args = []);

module build(args) 
{
    thickness = kv_get(polygon_points, "thickness");
    lip = kv_get(polygon_points, "lip");
    
    x1 = kv_get(polygon_points, "x1");
    x2= x1 + thickness;
    y1 = kv_get(polygon_points, "y1");
    y2 = y1 + thickness;
    y3 = kv_get(polygon_points, "y3");

    points = 
    [
        [0,0],
        [x1,0],
        [x1,y3],
        [x2,y3],
        [x2,-thickness],
        [-thickness,-thickness],
        [-thickness,y2],
        [lip,y2],
        [lip,y1],
        [0,y1],
        [0,0],
    ];

    linear_extrude(height=100)
    polygon(points=points);
}

module drawScrewHoles()
{
    translate([0, 0, 0])
    difference()
    {
        build();

        // Draw the screw holes
        color("Red")
        translate(kv_get(Screwholes, "move"))
        rotate(kv_get(Screwholes, "rotate"))
        cylinder(h=100, d=kv_get(Screwholes, "screw hole diameter"), center=true, $fn=kv_get(Screwholes, "screw hole fn"));
        
        color("Blue")
        translate([0, 0, kv_get(Screwholes, "x")])
        translate(kv_get(Screwholes, "move"))
        rotate(kv_get(Screwholes, "rotate"))
        cylinder(h=100, d=kv_get(Screwholes, "screw hole diameter"), center=true, $fn=kv_get(Screwholes, "screw hole fn"));

        color("Yellow")
        translate([0, kv_get(Screwholes, "z"), kv_get(Screwholes, "x")])
        translate(kv_get(Screwholes, "move"))
        rotate(kv_get(Screwholes, "rotate"))
        cylinder(h=100, d=kv_get(Screwholes, "screw hole diameter"), center=true, $fn=kv_get(Screwholes, "screw hole fn"));

        color("Green") 
        translate([0, kv_get(Screwholes, "z"), 0])
        translate(kv_get(Screwholes, "move"))
        rotate(kv_get(Screwholes, "rotate"))
        cylinder(h=100, d=kv_get(Screwholes, "screw hole diameter"), center=true, $fn=kv_get(Screwholes, "screw hole fn"));

        // Draw the countersink holes
        color("Red")
        translate(kv_get(Screwholes, "move countersink"))
        rotate(kv_get(Screwholes, "rotate"))
        cylinder(h=kv_get(Screwholes, "screw hole countersink depth"),
            d2=kv_get(Screwholes, "screw hole diameter"), 
            d1=kv_get(Screwholes, "screw hole countersink diameter"), 
            center=true, 
            $fn=kv_get(Screwholes, "screw hole fn"));
        
        color("Blue")
        translate([0, 0, kv_get(Screwholes, "x")])
        translate(kv_get(Screwholes, "move countersink"))
        rotate(kv_get(Screwholes, "rotate"))
        cylinder(h=kv_get(Screwholes, "screw hole countersink depth"),
            d2=kv_get(Screwholes, "screw hole diameter"), 
            d1=kv_get(Screwholes, "screw hole countersink diameter"), 
            center=true, 
            $fn=kv_get(Screwholes, "screw hole fn"));

        color("Yellow")
        translate([0, kv_get(Screwholes, "z"), kv_get(Screwholes, "x")])
        translate(kv_get(Screwholes, "move countersink"))
        rotate(kv_get(Screwholes, "rotate"))
        cylinder(h=kv_get(Screwholes, "screw hole countersink depth"),
            d2=kv_get(Screwholes, "screw hole diameter"), 
            d1=kv_get(Screwholes, "screw hole countersink diameter"), 
            center=true, 
            $fn=kv_get(Screwholes, "screw hole fn"));

        color("Green") 
        translate([0, kv_get(Screwholes, "z"), 0])
        translate(kv_get(Screwholes, "move countersink"))
        rotate(kv_get(Screwholes, "rotate"))
        cylinder(h=kv_get(Screwholes, "screw hole countersink depth"),
            d2=kv_get(Screwholes, "screw hole diameter"), 
            d1=kv_get(Screwholes, "screw hole countersink diameter"), 
            center=true, 
            $fn=kv_get(Screwholes, "screw hole fn"));

        // Draw the screw drivers holes
        color("Red")
        translate(kv_get(Screwholes, "move screw driver"))
        rotate(kv_get(Screwholes, "rotate"))
        cylinder(h=25, d=2 * kv_get(Screwholes, "screw hole diameter"), center=true, $fn=kv_get(Screwholes, "screw hole fn"));
        
        color("Blue")
        translate([0, 0, kv_get(Screwholes, "x")])
        translate(kv_get(Screwholes, "move screw driver"))
        rotate(kv_get(Screwholes, "rotate"))
        cylinder(h=25, d=2 *kv_get(Screwholes, "screw hole diameter"), center=true, $fn=kv_get(Screwholes, "screw hole fn"));

    }
}