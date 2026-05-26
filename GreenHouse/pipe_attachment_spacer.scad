/*
    copywrite 2/1/2021 Steven H. Mitchell
    zip-tie pipe anchor
    to modify the anchor, modify corrisponding dictionary value below.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <kvpairs.scad>;
$fn = 100;

anchor = 
[
        ["description", "0.75 in anchor"],
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
        ["description", "small hole anchor"]   ,
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
    ["description", "3/4 inch pipe"],
    ["diameter", convert_in2mm(0.85)],
    ["length", convert_in2mm(4)]
];

pipe_half_inch =
[
    ["description", "1/2 inch pipe"],
    ["diameter", convert_in2mm(0.75)],
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
    ["description", "#8 GRK cabinet screw"],
    ["diameter", GRK_cabinet_screw_shank_dia + 1],
    ["length", convert_in2mm(4)]
];

ziptie =
[
    ["description", "6 inch generic zip tie"],
    ["thickness", ziptie_thickness + 1],    
    ["width",  ziptie_width + 2],
    ["length", convert_in2mm(1)],
    ["move left", [1, 0, 0]],
    ["move right", [-1, 0, 0]],
    ["angle", 50]
];

ziptie2 =
[
    ["description", "6 inch generic zip tie"],
    ["thickness", ziptie_thickness + 2],    
    ["width",  ziptie_width + 2],
    ["length", convert_in2mm(1)],
    ["move left", [1, 0, 0]],
    ["move right", [-1, 0, 0]],    
    ["angle", 50]
];

ziptie_offset = 10;  //distance above base to start ziptie hole

build();

module build(args) 
{
    make_pipe_achor(small_hole_anchor, pipe_half_inch, screw_hole, ziptie);
}

module make_pipe_achor(spacer_properties, pipe_properties, screw_hole_properties, ziptie_properties)
{
    echo("------------------------------");
    echo("filename", kv_get( spacer_properties, "filename" ));
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

    color(kv_get(spacer_properties, "color"), 0.9)
    difference()
    {
        union()
        {
            linear_extrude( kv_get( spacer_properties, "height" ) + kv_get( spacer_properties, "additional_height" ) )
            square( size=[kv_get( spacer_properties, "width" ), kv_get( spacer_properties, "depth" ) ], center=true );        
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
    translate([0, kv_get(properties, "length")/2, kv_get(properties, "diameter")/2]) 
    rotate([90, 0, 0]) 
    {
        linear_extrude(kv_get(properties, "length"))
            circle(d=kv_get(properties, "diameter"));
    }
}

module make_screw_hole(properties)
{
    translate([0, 0, - kv_get(properties, "length") / 2]) 
        linear_extrude(kv_get(properties, "length"))
            circle(d=kv_get(properties, "diameter"));
}

module make_ziptie_hole(properties, left)
{
    // echo("Drawing ziptie with args: ", properties);
    if(left == true)
        {
            rotate([0, kv_get(properties, "angle"), 0])
            move_ziptie_to_center(properties, left = true) 
                linear_extrude(kv_get(properties, "length"))
                    square([kv_get(properties, "thickness"), kv_get(properties, "width")], center=true) ;             
        } 
        else 
        {
            rotate([0, - kv_get(properties, "angle"), 0])
            move_ziptie_to_center(properties, left = false) 
                linear_extrude(kv_get(properties, "length"))
                    square([kv_get(properties, "thickness"), kv_get(properties, "width")], center=true) ;            
        }
}

//translations
module move_screw_to_left_side(properties)
{
    translate(
        [
            - kv_get(properties, "width")/2 + kv_get(properties, "wall_thickness"), 
            kv_get(properties, "depth")/2 - kv_get(properties, "wall_thickness"),
            0
        ]) 
    children();
}

module move_screw_to_right_side(properties)
{
    translate(
        [
            kv_get(properties, "width")/2 - kv_get(properties, "wall_thickness"), 
            kv_get(properties, "depth")/2 - kv_get(properties, "wall_thickness"),
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
            kv_get(properties, "pipe_height") + kv_get(properties, "additional_height")
        ]) 
    children();
}

module move_ziptie_to_right(properties)
{
    translate(
        [ 
            (kv_get(properties, "width")/2 - kv_get(properties, "wall_thickness")) , 
            - (kv_get(properties, "depth")/2 - kv_get(properties, "wall_thickness") ), 
            ziptie_offset + kv_get(properties, "additional_height")
        ]
        )
    children();
}

module move_ziptie_to_left(properties)
{
    translate(
        [ 
            - (kv_get(properties, "width")/2 - kv_get(properties, "wall_thickness")) , 
            - (kv_get(properties, "depth")/2 - kv_get(properties, "wall_thickness")), 
            ziptie_offset + kv_get(properties, "additional_height")
        ]
        )
    children();
}

module move_ziptie_to_center(properties, left = true) 
{
    if(left == true)
    {
        translate(
        [ 
            kv_get(properties, "move left")[0] , 
            2, 
            -kv_get(properties, "length") / 2
        ]
        )
        children();
    }
    else
    {
        translate(
        [ 
            kv_get(properties, "move right")[0], 
            2, 
            -kv_get(properties, "length") / 2
        ]
        )
        children();
    }
}