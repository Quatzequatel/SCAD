/*
    This file makes a few different shapes for cable management.  
    The first is a simple cable clip style with screw hole.  
    The second is a saddle style clip with a hole for a screw.  
    The third is a cable and wire management organizer clip with a hole for a screw.
    the fourth is a container style cable management organizer with a hole for a screw. see https://www.thingiverse.com/thing:4120991
    this concept is good https://www.thingiverse.com/thing:648212 
    another good concept is https://www.thingiverse.com/thing:2159812
    

    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;

Wire = 
[   
    ["description", "dimension properties the wire"],
    ["radius", convert_in2mm(0.25)/2],
    ["diameter", convert_in2mm(0.25)],
    ["length",  convert_in2mm(0.5)],
    ["wall thickness", 4],
    ["screw hole", woodScrewShankDiaN_8],
    ["scale", [1,5]],
    ["angle", 270],
    ["start", 45],
    ["end", 315],
    ["move", [0, 0, 0]],
    ["rotate", [90, 0, 0]],
    ["color", "LightGrey"]
];

Clip = 
[   
    ["description", "Hexagon Nozzle Extension"],
    ["full length", kv_get(Wire, "length") * 3],
];

HullInfo = 
[   
    ["description", "HullInfo"],
    ["dia", 10],
    ["y", convert_in2mm(3)],
    ["move", [kv_get(Wire, "radius")*2, 0, 0]],
    ["rotate", [0, 0, 90]],
    ["z", convert_in2mm(0.5)],
];
// drawWedge();
build();
module build()
{
    drawClip();
}


module drawClip()
{

    difference()
    {
        union()
        {
            translate([0, 0, kv_get(Wire, "length") * 2])
            linear_extrude(height = kv_get(Wire, "length")*2, center = false, convexity = 10)
            drawShape();

            linear_extrude(height = kv_get(Wire, "length") *4, center = false, convexity = 10)
            drawHull();

            translate([0, 0, kv_get(Wire, "length") * 0])
            linear_extrude(height = kv_get(Wire, "length")*2, center = false, convexity = 10)
            drawShape(180);        
        }

        drawWedge();

    }
    
}

module drawShape(offset = 0)
{
    points1 = circle_points(
        r=kv_get(Wire, "radius"), 
        start=kv_get(Wire, "start")+15 + offset,
        end=kv_get(Wire, "end")-15 + offset, 
        increment=1); 

    points2 = circle_points(
        r=kv_get(Wire, "radius") + kv_get(Wire, "wall thickness"), 
        start=kv_get(Wire, "end") + offset, 
        end=kv_get(Wire, "start") + offset, 
        increment=-1);

    points = concat(points1, points2);
    polygon(points);
}


module drawHull()
{
    translate([-kv_get(Wire, "radius"), -kv_get(Wire, "radius") - kv_get(Wire, "wall thickness")/2, 0])
    hull()
    {
        circle(r = kv_get(Wire, "wall thickness")/2,  $fn = 100);
        translate(kv_get(HullInfo, "move"))
        circle(r = kv_get(Wire, "wall thickness")/2,  $fn = 100);
    }
}

module drawWedge()
{
    // union()

    translate([0, -kv_get(Wire, "radius"), kv_get(Wire, "length") * 2])
    rotate(-kv_get(Wire, "rotate"))
    translate([0, 0, -0.5])
    union()
    {
    linear_extrude(height = (kv_get(Wire, "radius")+ kv_get(Wire, "wall thickness")) * 2, scale= kv_get(Wire, "scale"), center = false, convexity = 10)
    hull()
    {
        translate([-10,0,0])
        circle(r = kv_get(Wire, "screw hole"),  $fn = 100);
        translate([10,0,0])
        circle(r = kv_get(Wire, "screw hole"),  $fn = 100);
    }

    drawScrewHole();        
    }

}

module drawScrewHole()
{
    cylinder(d = kv_get(Wire, "screw hole"), h = kv_get(Clip, "full length"), center = true, $fn = 100);
}

// Returns an array of [x,y] points on a circle
// r     = radius
// end = number of points
function circle_points(r, end, start = 0,  increment = 1) =
    [ for (i = [start : increment : end])
        let(a = i)
        [ r*cos(a), r*sin(a) ]
    ];

 
