/*
    copywrite 2/1/2021 Steven H. Mitchell
    zip-tie cylender anchor
    to modify the anchor, modify corrisponding dictionary value below.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
$fn = 100;

anchor = 
[
    "pump anchor",
        ["x-width", convert_in2mm(4.25)],    
        ["y-depth", NozzleWidth * 28],  //28 x 0.8 = 22.4
        ["z-height", 24],
        ["wall_thickness", NozzleWidth * 8],
        ["additional_height",  convert_in2mm(0)],
        ["cylender_base_location", 11],
        ["location", [0, 0, 0] ],  
        ["color", "Aqua"], 
];

pump_cylender =
[
    "8 cm diameter pump motor",
    ["diameter", 80],
    ["length", convert_in2mm(6)]
];

wire_channel = 
[
    "channel for wire to traverse thru",
    ["x-width", 10],
    ["y-length", 50],
    ["z-thickness", 6],
    ["location", [0,0,0]]
];

screw_hole =
[
    "#8 GRK cabinet screw",
    ["diameter", GRK_cabinet_screw_shank_dia + 1],
    ["length", convert_in2mm(4)]
];

ziptie =
[
    "6 inch generic zip tie",
    ["x-thickness", ziptie_thickness + 2],    
    ["y-width",  ziptie_width + 2],
    ["z-length", convert_in2mm(1)],
    ["angle", 40]
];

build();

module build(args) 
{
    make_pump_achor (
        anchor, 
        pump_cylender, 
        screw_hole, 
        ziptie, 
        wire_channel
        );
}

module make_pump_achor (
    spacer_properties, 
    cylender_properties, 
    screw_hole_properties, 
    ziptie_properties, 
    channel_properties
    )
{
    color(gdv(spacer_properties, "color"), 0.9)
    difference()
    {
        union()
        {
            linear_extrude( gdv( spacer_properties, "z-height" ) + gdv( spacer_properties, "additional_height" ) )
            square( size=[gdv( spacer_properties, "x-width" ), gdv( spacer_properties, "y-depth" ) ], center=true );        
        }      

        move_cylender(spacer_properties) 
            make_cylender(cylender_properties);
        move_wire_channel(spacer_properties, channel_properties) 
            make_wire_channel(channel_properties);

        move_screw_to_right_side(spacer_properties) 
            make_screw_hole(screw_hole);         
        move_screw_to_left_side(spacer_properties) 
            make_screw_hole(screw_hole); 

        move_ziptie_to_right(spacer_properties)
            make_ziptie_hole( ziptie_properties, false );

        move_ziptie_to_left(spacer_properties)
            make_ziptie_hole(ziptie_properties, true );
    }

}

module make_cylender(properties)
{
    //center on y axis
    translate([0, gdv(properties, "length")/2, gdv(properties, "diameter")/2]) 
    rotate([90, 0, 0]) 
    {
        linear_extrude(gdv(properties, "length"))
            circle(d=gdv(properties, "diameter"));
    }
}

module make_wire_channel(properties)
{
    linear_extrude(gdv(properties, "z-thickness"))
        square(size = [gdv(properties, "x-width"), gdv(properties, "y-length")], center = true);
}

module make_screw_hole(properties)
{
    translate([0, 0, - gdv(properties, "length") / 2]) 
        linear_extrude(gdv(properties, "length"))
            circle(d=gdv(properties, "diameter"));
}

module make_ziptie_hole(properties, left)
{
    if(left == true)
        {
            rotate([0, gdv(properties, "angle"), 0])
            move_ziptie_to_center(properties) 
                linear_extrude(gdv(properties, "z-length"))
                    square([gdv(properties, "x-thickness"), gdv(properties, "y-width")], center=true) ;             
        } 
        else 
        {
            rotate([0, - gdv(properties, "angle"), 0])
            move_ziptie_to_center(properties) 
                linear_extrude(gdv(properties, "z-length"))
                    square([gdv(properties, "x-thickness"), gdv(properties, "y-width")], center=true) ;            
        }
}

//translations
module move_screw_to_left_side(properties)
{
    translate(
        [
            - gdv(properties, "x-width")/2 + gdv(properties, "wall_thickness"), 
            gdv(properties, "y-depth")/2 - gdv(properties, "wall_thickness"),
            0
        ]) 
    children();
}

module move_screw_to_right_side(properties)
{
    translate(
        [
            gdv(properties, "x-width")/2 - gdv(properties, "wall_thickness"), 
            gdv(properties, "y-depth")/2 - gdv(properties, "wall_thickness"),
            0
        ]) 
    children();
}

module move_cylender(properties)
{
    translate(
        [
            0, 
            0,
            gdv(properties, "cylender_base_location") + gdv(properties, "additional_height")
        ]) 
    children();
}

module move_wire_channel(anchor_properties, channel_properties)
{
    translate(
        [
            0,
            0,
            (gdv(anchor_properties, "cylender_base_location") - gdv(channel_properties, "z-thickness")) + 1
        ]
    )
    children();
}

module move_ziptie_to_right(properties)
{
    translate(
        [ 
            (gdv(properties, "x-width")/2 - gdv(properties, "wall_thickness")) , 
            - (gdv(properties, "y-depth")/2 - gdv(properties, "wall_thickness") ), 
            15 + gdv(properties, "additional_height")
        ]
        )
    children();
}

module move_ziptie_to_left(properties)
{
    translate(
        [ 
            - (gdv(properties, "x-width")/2 - gdv(properties, "wall_thickness")) , 
            - (gdv(properties, "y-depth")/2 - gdv(properties, "wall_thickness") ), 
            15 + gdv(properties, "additional_height")
        ]
        )
    children();
}

module move_ziptie_to_center(properties) {
        translate(
        [ 
            0, 
            0, 
            -gdv(properties, "z-length") / 2
        ]
        )
    children();
}