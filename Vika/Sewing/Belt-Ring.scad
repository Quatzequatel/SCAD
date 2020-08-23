/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

$fn=100;

Belt_O_Ring_D_10 = 
[
    "Belt_O_Ring_D_10",
    ["ring od" , 100],
    ["ring id" , 80],
    ["height", 5],
    ["color", "LightGrey"]
];

Belt_O_Ring_D_5 = 
[
    "Belt_O_Ring_D_5",
    ["ring od" , 50],
    ["ring id" , 40],
    ["height", 5],
    ["color", "LightGrey"]
];

Belt_O_Ring_D_2_5 = 
[
    "Belt_O_Ring_D_2_5",
    ["ring od" , 25],
    ["ring id" , 20],
    ["height", 5],
    ["color", "LightGrey"]
];

// ring(ringD_2_5);
ring2(Belt_O_Ring_D_5);
ring2(Belt_O_Ring_D_2_5);

module ring(ring_d) 
{
    linear_extrude(gdv(ring_d, "height"))
    difference()
    {
        circle(d=gdv(ring_d, "ring od"));
        circle(d=gdv(ring_d, "ring id"));
    }
}
module ring2(ring_d)
{
    echo(str("file name = ", ring_d.x, "   "));
    rotate_extrude(angle = 360)
    translate([gdv(ring_d, "ring id"),0,0])
    circle(d=gdv(ring_d, "height"));
}