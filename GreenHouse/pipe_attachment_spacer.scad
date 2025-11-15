/*
    copywrite 2/1/2021 Steven H. Mitchell
    zip-tie pipe anchor
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
    "0.75 in anchor",
        ["width", convert_in2mm(2)],    
        ["depth", convert_in2mm(0.75)],  
        ["height", convert_in2mm(0.75)],  //base model height, for ziptie holes
        ["wall_thickness", NozzleWidth * 8],
        ["additional_height",  convert_in2mm(0)], //use this to increase height of spacer.
        ["pipe_height", convert_in2mm(0.2)],
        ["location", [0, 0, 0] ],  
        ["color", "Aqua"], 
];

small_hole_anchor = 
[
    "small hole anchor",
        ["width", convert_in2mm(2)],    
        ["depth", convert_in2mm(0.75)],  
        ["height", convert_in2mm(0.45)],  //base model height, for ziptie holes
        ["wall_thickness", NozzleWidth * 8],
        ["additional_height",  convert_in2mm(0)], //use this to increase height of spacer.
        ["pipe_height", convert_in2mm(0.15)],
        ["location", [0, 0, 0] ],  
        ["color", "Aqua"], 
        ["filename", "Electric cord anchor.stl"],
];

pipe_theequarter_inch =
[
    "3/4 inch pipe",
    ["diameter", convert_in2mm(0.85)],
    ["length", convert_in2mm(4)]
];

pipe_half_inch =
[
    "1/2 inch pipe",
    ["diameter", convert_in2mm(0.4)],
    ["length", convert_in2mm(4)]
];

pipe_one_inch =
[
    "inch pipe",
    ["diameter", convert_in2mm(1.1)],
    ["length", convert_in2mm(4)]
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
    ["thickness", ziptie_thickness + 2],    
    ["width",  ziptie_width + 2],
    ["length", convert_in2mm(1)],
    ["angle", 30]
];

ziptie2 =
[
    "6 inch generic zip tie",
    ["thickness", ziptie_thickness + 2],    
    ["width",  ziptie_width + 2],
    ["length", convert_in2mm(1)],
    ["angle", 50]
];

ziptie_offset = 10;  //distance above base to start ziptie hole

build();

module build(args) 
{
    make_pipe_achor(small_hole_anchor, pipe_half_inch, screw_hole, ziptie2);
}

module make_pipe_achor(spacer_properties, pipe_properties, screw_hole_properties, ziptie_properties)
{
    echo("------------------------------");
    echo("filename", gdv( spacer_properties, "filename" ));
    echo("------------------------------");
    echo("------------------------------");
    echo("Drawing spacer_properties with args: ", spacer_properties);
    echo("------------------------------");
    echo("Drawing pipe_properties with args: ", pipe_properties);
    echo("------------------------------");
    echo("Drawing screw_hole_properties with args: ", screw_hole_properties);
    echo("------------------------------");
    echo("Drawing ziptie with args: ", ziptie_properties);
    echo("------------------------------");

    color(gdv(spacer_properties, "color"), 0.9)
    difference()
    {
        union()
        {
            linear_extrude( gdv( spacer_properties, "height" ) + gdv( spacer_properties, "additional_height" ) )
            square( size=[gdv( spacer_properties, "width" ), gdv( spacer_properties, "depth" ) ], center=true );        
        }      

        move_pipe(spacer_properties) make_pipe(pipe_properties);

        move_screw_to_right_side(spacer_properties) make_screw_hole(screw_hole);         
        move_screw_to_left_side(spacer_properties) make_screw_hole(screw_hole); 

        move_ziptie_to_right(spacer_properties)
        #make_ziptie_hole( ziptie_properties, false );

        move_ziptie_to_left(spacer_properties)
        #make_ziptie_hole(ziptie_properties, true );
    }

}

module make_pipe(properties)
{
    translate([0, gdv(properties, "length")/2, gdv(properties, "diameter")/2]) 
    rotate([90, 0, 0]) 
    {
        linear_extrude(gdv(properties, "length"))
            circle(d=gdv(properties, "diameter"));
    }
}

module make_screw_hole(properties)
{
    translate([0, 0, - gdv(properties, "length") / 2]) 
        linear_extrude(gdv(properties, "length"))
            circle(d=gdv(properties, "diameter"));
}

module make_ziptie_hole(properties, left)
{
    // echo("Drawing ziptie with args: ", properties);
    if(left == true)
        {
            rotate([0, gdv(properties, "angle"), 0])
            move_ziptie_to_center(properties) 
                linear_extrude(gdv(properties, "length"))
                    square([gdv(properties, "thickness"), gdv(properties, "width")], center=true) ;             
        } 
        else 
        {
            rotate([0, - gdv(properties, "angle"), 0])
            move_ziptie_to_center(properties) 
                linear_extrude(gdv(properties, "length"))
                    square([gdv(properties, "thickness"), gdv(properties, "width")], center=true) ;            
        }
}

//translations
module move_screw_to_left_side(properties)
{
    translate(
        [
            - gdv(properties, "width")/2 + gdv(properties, "wall_thickness"), 
            gdv(properties, "depth")/2 - gdv(properties, "wall_thickness"),
            0
        ]) 
    children();
}

module move_screw_to_right_side(properties)
{
    translate(
        [
            gdv(properties, "width")/2 - gdv(properties, "wall_thickness"), 
            gdv(properties, "depth")/2 - gdv(properties, "wall_thickness"),
            0
        ]) 
    children();
}

module move_pipe(properties)
{
    translate(
        [
            0, 
            0,
            gdv(properties, "pipe_height") + gdv(properties, "additional_height")
        ]) 
    children();
}

module move_ziptie_to_right(properties)
{
    translate(
        [ 
            (gdv(properties, "width")/2 - gdv(properties, "wall_thickness")) , 
            - (gdv(properties, "depth")/2 - gdv(properties, "wall_thickness") ), 
            ziptie_offset + gdv(properties, "additional_height")
        ]
        )
    children();
}

module move_ziptie_to_left(properties)
{
    translate(
        [ 
            - (gdv(properties, "width")/2 - gdv(properties, "wall_thickness")) , 
            - (gdv(properties, "depth")/2 - gdv(properties, "wall_thickness")), 
            ziptie_offset + gdv(properties, "additional_height")
        ]
        )
    children();
}

module move_ziptie_to_center(properties) {
        translate(
        [ 
            0, 
            2, 
            -gdv(properties, "length") / 2
        ]
        )
    children();
}