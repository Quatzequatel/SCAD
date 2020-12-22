/* 
sacuers for planters.
Design 1
just a spacer under the planter to protect the wood.

design 2
a saucer that captures drained.
*/

/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

$fn=360;


Build();

module Build()
{
    Saucer(kombucha_saucer_properties);
}

module Saucer(properties) 
{
    rotate_extrude(convexity=10) 
    {
        union()
        {
            hull() 
            {
                translate([gdv(properties, "radius"), 0, 0]) 
                    square(size=[gdv(properties, "thickness"), gdv(properties, "thickness")], center=false);

                square(size=[gdv(properties, "thickness"), gdv(properties, "thickness")], center=false);        
            }
            translate([gdv(properties, "radius") +  gdv(properties, "wall thickness") / 2, gdv(properties, "wall thickness") / 2, 0])
            hull()
            {
                translate([sin(10) * gdv(properties, "height"), gdv(properties, "height"), 0]) 
                circle(r =gdv(properties, "wall thickness") / 2); 
                circle(r = gdv(properties, "wall thickness") / 2);                
            }   

            // rotate([0,0,230])
            translate([0, gdv(properties, "wall thickness") / 2, 0])
            polygon(points = 
                [
                    [
                        gdv(properties, "radius") - gdv(properties, "radius")/20, 0], 
                        [gdv(properties, "radius"), 0], 
                        [gdv(properties, "radius") + (gdv(properties, "height") * sin(5)), 
                        gdv(properties, "height")/2
                    ]
                ]);     
        }        
    }

}

function StepSize(stepsize) = stepsize * 180/$fn;
function polySinWave(width, height) =
[
    for(x =[0 : StepSize(1) : 181]) [ x * width/90,  sin(x) * height]
];

kombucha_saucer_properties = 
[
    "kombucha_saucer",
    ["radius", 95/2],
    ["height", 10],
    ["thickness", LayersToHeight(10)],
    ["wall thickness", WallThickness(2)],
    ["color", "WhiteSmoke"],
    ["alpha value", 0.5],
    ["spacing", convert_in2mm(0.25)]
];

medium_saucer_properties = 
[
    "medium_saucer",
    ["radius", convert_in2mm(8.5)/2],
    ["height", convert_in2mm(1)],
    ["thickness", LayersToHeight(6)],
    ["wall thickness", WallThickness(2)],
    ["color", "WhiteSmoke"],
    ["alpha value", 0.5],
    ["location", [0, 0, 0]],
    ["spacing", convert_in2mm(0.25)]
];

large_saucer_properties = 
[
    "large_saucer",
    ["radius", convert_in2mm(10.5)/2],
    ["height", convert_in2mm(1)],
    ["thickness", LayersToHeight(6)],
    ["wall thickness", WallThickness(2)],
    ["color", "WhiteSmoke"],
    ["alpha value", 0.5],
    ["location", [0, 0, 0]],
    ["spacing", convert_in2mm(0.25)]
];

exttra_large_saucer_properties = 
[
    "exttra_large_saucer",
    ["radius", convert_in2mm(12.5)/2],
    ["height", convert_in2mm(1)],
    ["thickness", LayersToHeight(6)],
    ["wall thickness", WallThickness(2)],
    ["color", "WhiteSmoke"],
    ["alpha value", 0.5],
    ["location", [0, 0, 0]],
    ["spacing", convert_in2mm(0.25)]
];