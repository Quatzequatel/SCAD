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
    ["nozzle connection length", 26],
    ["z2", 26],
    ["z3", 7],
    ["core inner dia", 22],
    ["core outer dia", 25],
    ["Extension inner dia", 19],
    ["Extension lock dia", 0.4],
    ["angle", 120],
    ["move", [0, 0, 0]],
    ["rotate", [0, 0, 0]],
    ["color", "LightGrey"]
];

module NozzleExtension() 
{
    color(kv_get(Part, "color"))
    rotate(kv_get(Part, "rotate"))
    translate([0, 0, kv_get(Part, "nozzle connection length")])
    union()
    {
        linear_extrude(height = kv_get(Part, "nozzle connection length"), center = false, convexity = 10)
        difference()
        {
            circle(r = kv_get(Part, "core outer dia")/2, $fn = 6);
            circle(r = kv_get(Part, "core inner dia")/2, $fn = 6);
        }

        translate([0, 0, kv_get(Part, "nozzle connection length")/2 + 7])
        rotate_extrude(convexity = 10)
            translate([kv_get(Part, "core inner dia")/2 -0.5, 0, 0])
                circle(r = kv_get(Part, "Extension lock dia"), $fn = 100);

    }

        linear_extrude(height = kv_get(Part, "nozzle connection length"), center = false, convexity = 10)
        difference()
        {
            circle(r = kv_get(Part, "core inner dia")/2, $fn = 100);
            circle(r = kv_get(Part, "Extension inner dia")/2, $fn = 100);
        }    
}

NozzleExtension();