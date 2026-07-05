/*
  Cube with cutout for cable.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;

Block = 
[   
    ["description", "Hexagon Nozzle Extension"],
    ["x", convert_in2mm(5)],
    ["y", convert_in2mm(3)],
    ["z", convert_in2mm(0.5)],
];

HullInfo = 
[   
    ["description", "HullInfo"],
    ["dia", 10],
    ["y", convert_in2mm(3)],
    ["move", [kv_get(Block, "x"), 0, 0]],
    ["rotate", [0, 0, 90]],
    ["z", convert_in2mm(0.5)],
];

build();
module build()
{
    drawBlock();
    drawHull();
}

module drawBlock()
{
    difference()
    {
        linear_extrude(height = kv_get(Block, "z"), center = false, convexity = 10)
        square([kv_get(Block, "x"), kv_get(Block, "y")], center = true);

        union()
        {
            drawHull();
            rotate(kv_get(HullInfo, "rotate"))
            drawHull();            
        }


    }
}

module drawHull()
{
    translate(-[kv_get(HullInfo, "move")[0]/2,0,0])
    hull()
    {
        cylinder(r = kv_get(HullInfo, "dia")/2, h = kv_get(HullInfo, "z"), center = true, $fn = 32);
        translate(kv_get(HullInfo, "move"))
        cylinder(r = kv_get(HullInfo, "dia")/2, h = kv_get(HullInfo, "z"), center = true, $fn = 32);
    }
}