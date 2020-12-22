/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

build(roofcap_prop);

module build(properties) 
{
    roof_capz_v2(properties);
}

module roof_capz_v2(properties)
{
    difference()
    {
        polygon(points=triangle(gdv(properties, "top_width"), gdv(properties, "top_height")));        

        translate([0, -gdv(properties, "top_thickness")])
        polygon(points=triangle(gdv(properties, "top_width"), gdv(properties, "top_height")));  
    }

    translate([0, -gdv(properties, "base_height"), 0]) 
    difference()
    {
        square(size=[gdv(properties, "base_width"), gdv(properties, "base_height")], center=false);
        translate([gdv(properties, "top_thickness"),gdv(properties, "top_thickness"),0,])
        square(size=[gdv(properties, "base_width")-2 * gdv(properties, "top_thickness"), gdv(properties, "base_height")], center=false);
    }
    
 
       
}

flashing_width = convert_in2mm(6);

function triangle(w, h, o = [0,0]) = [o, [w,o.y], [o.x + w/2, o.y + h]];

roofcap_prop = 
[
    "roofcap_prop",
        ["top_width", 1224 * 2],
        ["length", flashing_width] ,
        ["top_height", 1102],
        ["top_angle", 42],
        ["top_thickness", 13.35],
        ["base_height", 1800],
        ["base_width", 1224 * 2],
        ["location", 
            [
                hypotenuse(flashing_width, flashing_width)/2, 
                // convert_in2mm(58.0), 
                // sideAaA(HouseLength/2, aA = 42),
                ((HouseLength/2)/tan(48) - 90) + convert_in2mm(5),
                0
            ]
        ],
        ["rotate", [0, 0, 135]],
        ["color", "pink"]
];

L_Flashing_bag = 
[
    "L_Flashing_bag",
        ["width", flashing_width],
        ["length", flashing_width] ,
        ["height", convert_in2mm(96)],
        ["thickness", 3],
        ["location", 
            [
                hypotenuse(flashing_width, flashing_width)/2, 
                // convert_in2mm(58.0), 
                // sideAaA(HouseLength/2, aA = 42),
                ((HouseLength/2)/tan(48) - 90) + convert_in2mm(5),
                0
            ]
        ],
        ["rotate", [0, 0, 135]],
        ["color", "pink"]
];