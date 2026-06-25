include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;

Part = 
[   
    ["description", "Bracket for Trellis, for use with 3/4 inch wood brace."],
    ["x", convert_in2mm(0.75)],
    ["y", convert_in2mm(0.75)],
    ["z1", 26],
    ["z2", 26],
    ["z3", 7],
    // ["radius", 18.8],
    ["radius1", convert_in2mm(0.3)],
    ["diameter1", 13],
    ["wall thickness", 4],
    ["radius2", 25],
    ["radius3", 19],
    ["angle", 45],
    ["move", [-5, 0, 5.8]],
    ["rotate", [0, -45, 0]],
    ["rotate2", [0, -46, 0]],
    ["color", "LightGrey"]
];

TrellisBracket() ;

module TrellisBracket() 
{

    difference()
    {
        union()
        {
            drawBox();
            drawCylinder();
        }

        innerBox();
        innerCylinder();

        translate([0,0,-1])
        linear_extrude(height = 2, center = false, convexity = 10)
        square([kv_get(Part, "x") + kv_get(Part, "wall thickness")+10, kv_get(Part, "y") + kv_get(Part, "wall thickness")+10], center = true);
    }

}

module drawBox()
{
        linear_extrude(height = kv_get(Part, "z1"), center = false, convexity = 10)
        difference()
        {
            square([kv_get(Part, "x") + kv_get(Part, "wall thickness"), kv_get(Part, "y") + kv_get(Part, "wall thickness")], center = true);
            square([kv_get(Part, "x"), kv_get(Part, "y")], center = true);
        }
}

module innerBox()
{
        linear_extrude(height = kv_get(Part, "z1"), center = false, convexity = 10)
        square([kv_get(Part, "x"), kv_get(Part, "y")], center = true);
}

module drawCylinder()
{
    translate(kv_get(Part, "move"))
    rotate(kv_get(Part, "rotate"))

    linear_extrude(height = kv_get(Part, "z2"), center = false, convexity = 10)
    difference()
    {
        circle(d = kv_get(Part, "diameter1") + 2 * kv_get(Part, "wall thickness"), $fn = 100);
        circle(d = kv_get(Part, "diameter1"), $fn = 100);                
    }       
}   

module innerCylinder()
{
    translate(kv_get(Part, "move"))
    rotate(kv_get(Part, "rotate2"))

    linear_extrude(height = kv_get(Part, "z2")+2, center = false, convexity = 10)
    hull()
    {
        circle(d = kv_get(Part, "diameter1"), $fn = 100);   
        translate([-7, 0, 0])
        circle(d = kv_get(Part, "diameter1"), $fn = 100);
    }
                 
}