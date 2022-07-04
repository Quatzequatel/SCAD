/*
    to make boxes for 2 Wago 
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

Wago221_2port = 
[
    "Wago 221 2 conductor connector nuts",
    ["x", 13.2],
    ["y", 18.8],
    ["z", 8.4],
    ["wall count",  4],
    ["floor layers", 12]
];

Wago221_3port = 
[
    "Wago 221 3 conductor connector nuts",
    ["x", 18.8],
    ["y", 18.6],
    ["z", 8.4],
    ["wall count",  4],
    ["floor layers", 12]
];


Wago221_5port = 
[
    "Wago 221 5 conductor connector nuts",
    ["x", 30],
    ["y", 18.6],
    ["z", 8.4],
    ["wall count",  4],
    ["floor layers", 12]
];

build();

module build(args) 
{
    // make_box_for_2_3port_nuts();
    // make_box_for_3_3port_nuts();

    // translate([0,0, LayersToHeight(gdv(Wago221_3port, "floor layers"))])
    // #linear_extrude(height = gdv(Wago221_3port,"y" ))
    // circle(1, $fn=60);

    // translate([2 *gdv(Wago221_3port, "x"),0,0])
    // make_box_for_2_2port_nuts();
    // make_box_for_3_5port_nuts();
    make_box_for_2_5port_nuts();
}

module make_box_for_2_5port_nuts()
{
    echo("name file, 2x Wago_221-5port enclosure.stl");
    open_box(Wago221_5port, 2);
}

module make_box_for_3_5port_nuts()
{
    echo("name file, 3x Wago_221-5port enclosure.stl");
    open_box(Wago221_5port, 3);
}

module make_box_for_2_3port_nuts()
{
    echo("name file, 2x Wago_221-3port enclosure.stl");
    open_box(Wago221_3port, 2);
}

module make_box_for_3_3port_nuts()
{
    echo("name file, 3x Wago_221-3port enclosure.stl");
    open_box(Wago221_3port, 3);
}

module make_box_for_2_2port_nuts()
{
    echo("name file, 2x Wago_221-2port enclosure.stl");
    open_box(Wago221_2port, 2);
}

module open_box(args, clips = 2) 
{
    //rotate axis to create box with 2 clips inserted into box
    x = clips * gdv(args, "z");
    y = gdv(args, "x");
    z = gdv(args, "y");
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