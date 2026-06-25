include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;

Part = 
[   
    ["description", "Hexagon Nozzle Extension"],
    ["x", convert_in2mm(5)],
    ["y", convert_in2mm(3)],
    ["z1", 26],
    ["z2", 26],
    ["z3", 7],
    // ["radius", 18.8],
    ["radius1", 22],
    ["radius2", 25],
    ["radius3", 19],
    ["angle", 120],
    ["move", [0, 0, 0]],
    ["rotate", [0,0, 0]],
    ["color", "LightGrey"]
];

module NozzleExtension() 
{
    color(kv_get(Part, "color"))
    rotate(kv_get(Part, "rotate"))
    // translate(kv_get(Part, "move"))
    translate([0, 0, kv_get(Part, "z1")])
    union()
    {
        linear_extrude(height = kv_get(Part, "z1"), center = false, convexity = 10)
        difference()
        {
            circle(r = kv_get(Part, "radius2")/2, $fn = 6);
            circle(r = kv_get(Part, "radius1")/2, $fn = 6);
        }

        translate([0, 0, kv_get(Part, "z1")/2 + 7])
        rotate_extrude(convexity = 10)
            translate([kv_get(Part, "radius1")/2 -0.5, 0, 0])
                circle(r = 0.25, $fn = 100);

    }

        linear_extrude(height = kv_get(Part, "z1"), center = false, convexity = 10)
        difference()
        {
            circle(r = kv_get(Part, "radius1")/2, $fn = 100);
            circle(r = kv_get(Part, "radius3")/2, $fn = 100);
        }    
}


// rotate([90, 0, 0])
NozzleExtension();