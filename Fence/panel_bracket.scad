/*
    copywrite 2/1/2021 Steven H. Mitchell
    fence bracket, goes under top frame of 0.75" + 0.75" + 1.5" and attacheds to 
    true 4" post. using GRK_#8_cabinet_screw
    to modify bracket, modify corrisponding dictionaries values below.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
$fn = 100;

back_plate = 
[
    "back_plate",
    ["x-width", 102],
    ["y-length", 60],
    ["z-thickness", LayersToHeight(14)],
    ["wall_thickness", NozzleWidth * 8],
    ["color", "Silver"]
];

fence_cut = 
[
    "fence beam",
    ["x-width", 70],
    ["y-length", 40],
    ["z-thickness", convert_in2mm(4)]
];

bracket = 
[
    "bracket",
    ["x-width", gdv(fence_cut, "x-width") + 2 * gdv(back_plate, "wall_thickness")],
    ["y-length", gdv(fence_cut, "y-length") + gdv(back_plate, "wall_thickness")],
    ["z-thickness", LayersToHeight(60)],
];

screw_hole =
[
    "#8 GRK cabinet screw",
    ["diameter", GRK_cabinet_screw_shank_dia + 1],
    ["length", convert_in2mm(4)]
];

build();

module build(args) 
{
    make_bracket (
        back_plate,
        screw_hole,
        bracket,
        fence_cut
        );
}

module make_bracket(back_plate, screw_hole, bracket, beam)
{
    color(gdv(back_plate, "color"), 0.9)
    difference()
    {
        union()
        {
            linear_extrude( gdv( back_plate, "z-thickness" ) ) 
            square( size=[gdv( back_plate, "x-width" ), gdv( back_plate, "y-length" ) ], center=true );   

            move_to_top(back_plate, bracket)
            linear_extrude( gdv( bracket, "z-thickness" ) ) 
            square( size=[gdv( bracket, "x-width" ), gdv( bracket, "y-length" ) ], center=true );        
        } 

        move_screw(back_plate, 0) make_screw_hole(screw_hole);
        move_screw(back_plate, 1) make_screw_hole(screw_hole);
        move_screw(back_plate, 2) make_screw_hole(screw_hole);
        move_screw(back_plate, 3) make_screw_hole(screw_hole);

        translate([0,0,-20])
        move_to_top(back_plate, beam)
        union()
        {
            linear_extrude( gdv( beam, "z-thickness" ) ) 
            square( size=[gdv( beam, "x-width" ), gdv( beam, "y-length" ) ], center=true );        
        }         
    }
}

module move_to_top(plate, object)
{
    translate
    (
        [
            0,
            gdv(plate, "y-length") /2 - gdv(object, "y-length")/2,
            0,
        ]
    )
    children();
}

module make_screw_hole(properties)
{
    translate([0, 0, - gdv(properties, "length") / 2]) 
        linear_extrude(gdv(properties, "length"))
            circle(d=gdv(properties, "diameter"));
}

module move_screw(properties, idx)
{
    translate(
    [
        (gdv(properties, "x-width")/2 * (idx % 2 ? 1 : -1)) 
            + gdv(properties, "wall_thickness") * (idx % 2 ? -1 : 1), 
        (gdv(properties, "y-length")/2 * (idx < 2 ? 1 : -1)) 
            + gdv(properties, "wall_thickness") * (idx < 2 ? -1 : 1),
        0
    ])    
    children();       
}