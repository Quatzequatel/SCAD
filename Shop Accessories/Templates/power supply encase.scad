/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

power_supply = 
[
    "60w power supply",
    ["x", convert_in2mm(5.66)],
    ["y", convert_in2mm(1.85)],
    ["z", convert_in2mm(1.33)],
    ["wall count",  4],
    ["floor layers", 12],
    ["color", "silver"]
];

dc_wire =
[
    "DC wire details",
    ["rotation", [0,0,0]]
    ["top location", 16.6 ]
    ["diameter", 6.6],
    ["color", "red"],
];

ac_wire =
[
    "AC wire details",
    ["rotation", [0,0,0]]
    ["top location", 16.6 ]
    ["diameter", 6.5],
    ["color", "black"],
];

power_supply_case = 
[
    "60w power supply enclosure",
    ["x", convert_in2mm(9)],
    ["y", 2 * gdv(power_supply, "y")],
    ["z", 2 * gdv(power_supply, "z")],
    ["wall count",  4],
    ["floor layers", 12],
    ["color", "Gainsboro"]
];

build();

module build(args) 
{
    Thing();
}

module Thing()
{
    applyColor(power_supply_case)
    Box_bottom(power_supply_case);

    applyColor(power_supply)
    translate([0,0,LayersToHeight(gdv(power_supply, "floor layers"))])
    draw_Box(power_supply);
}

module Box_bottom(args, clips = 1) 
{
    //rotate axis to create box with 2 clips inserted into box
    x = clips * gdv(args, "x");
    y = gdv(args, "y");
    z = gdv(args, "z");
    wall = WallThickness(gdv(args, "wall count"));
    floorheight = LayersToHeight(gdv(args, "floor layers"));

    difference()
    {
        linear_extrude(height = z + wall)
        //wall * 2, for each side of box.
        square([x + 2*wall, y + 2*wall], center = true);

        translate([0,0,floorheight])
        linear_extrude(height = z + 1)
        square([x, y], center = true);
    }    
}

module draw_Box(args)
{
    x = gdv(args, "x");
    y = gdv(args, "y");
    z = gdv(args, "z");

        linear_extrude(height = z)
        square([x, y], center = true);    
}