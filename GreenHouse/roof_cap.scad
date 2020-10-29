/*
    
*/

include <constants.scad>;
include <GreenHouseProperties.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
use <Roof.scad>;

build();

module build(args) 
{
    // GreenHouseProperties_Info();
    // Info();
    roof_cap();
}

module roof_cap()
{
    // rotate([-90, 90, 0]) 
    // add_rafter(Rafter_Main);  
    add_rafter_beam(Rafter_EndCap);

    L_Flashing(L_Flashing_bag);
}

module L_Flashing(properties)
{
        color(gdv(properties, "color"), 0.5)
        translate(gdv(properties, "location"))
        rotate(gdv(properties, "rotate"))
        linear_extrude(gdv(properties, "height"))
        polygon(
            points = 
                L_Flashing_points(
                    w = gdv(properties, "width"), 
                    l = gdv(properties, "length"), 
                    t = gdv(properties, "thickness")
            )
        );
}

flashing_width = convert_in2mm(6);
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

function L_Flashing_points(w, l, t, o = [0,0]) = //echo(w = w, l = l, o = o)
[
    [o.x, o.y],
    [o.x + w, o.y],
    [o.x + w, o.y + l],
    [o.x + w - t, o.y + l],
    [o.x + w - t, o.y + t],
    [o.x, o.y + t]
];