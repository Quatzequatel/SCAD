/*
    
*/

include <constants.scad>;
include <GardenLibrary.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;


Garden_manifold_Cover();

module Garden_manifold_Cover()
{
    cover = [
        "Manifold Sides",
        ["x", convert_in2mm(19)],  //length
        ["y", convert_in2mm(21)],  //width
        ["z", convert_in2mm(6)],  //height
        ["thickness", convert_in2mm(0.75)],
        ["color", "Red"]
    ];

    deck = [
        "Deck Board",
        ["x", convert_in2mm(19)],  //length
        ["y", convert_in2mm(5.5)],  //width
        ["z", convert_in2mm(0.75)],  //height
        ["thickness", convert_in2mm(0.75)],
        ["spacer", convert_in2mm(1/16)],
        ["color", "LightGrey"]
    ];

    //board1
    translate([0, gdv(cover, "y") +  gdv(cover, "thickness") , 0])
    union()
    {
        board(cover, "x", "thickness", "z");
        translate([2 *gdv(cover, "thickness"), -2 *gdv(cover, "thickness"), 0])
        text(str("board 1, ", gdv(cover, "x")/10, " cm, 19 in"), size = 20);
    }
    
    //board2
    board(cover, "x", "thickness", "z");
    translate([2 *gdv(cover, "thickness"), -2 *gdv(cover, "thickness"), 0])
    text(str("board 2, ", gdv(cover, "x")/10, " cm"), size = 20);

    //board 3
    translate([0, gdv(cover, "thickness"), 0])
    color(gdv(cover, "color"), 0.5)
    union()
    {
        board(cover, "thickness", "y", "z");
        translate([2 * gdv(cover, "thickness"), gdv(cover, "y")/2, 0])
        text(str("board 3, ", gdv(cover, "y")/10, " cm"), size = 20);
    }
    
    //board4
    translate([gdv(cover, "x") - gdv(cover, "thickness"), gdv(cover, "thickness"), 0])
    color(gdv(cover, "color"), 0.5)
    union()
    {
        board(cover, "thickness", "y", "z");
        translate([2 * gdv(cover, "thickness"), gdv(cover, "y")/2, 0])
        text(str("board 4, ", gdv(cover, "y")/10, " cm", ", 21 in"), size = 20);
    }

    //deck board 1
    translate([0, 0, gdv(cover, "z")])
    color(gdv(deck, "color"), 0.5)
    board(deck, "x", "y", "z");

    //deck board 2
    translate([0, gdv(deck, "y") + gdv(deck, "spacer"), gdv(cover, "z")])
    color(gdv(deck, "color"), 0.5)
    board(deck, "x", "y", "z");

    //deck board 3
    translate([0, 2 * (gdv(deck, "y") + gdv(deck, "spacer")), gdv(cover, "z")])
    color(gdv(deck, "color"), 0.5)
    board(deck, "x", "y", "z");

    //deck board 4
    translate([0, 3 * (gdv(deck, "y") + gdv(deck, "spacer")), gdv(cover, "z")])
    color(gdv(deck, "color"), 0.5)
    board(deck, "x", "y", "z");
}

module board(values, dim1, dim2, dim3)
{
    translate([gdv(values, dim1)/2, gdv(values, dim2)/2, 0])
    linear_extrude(gdv(values, dim3))    
    square(size=[gdv(values, dim1), gdv(values, dim2)], center=true);
}

module EMT_Conduit_Bracket(args) 
{
    //save file as "EMT_Conduit_Bracket.stl"
    translate([50, 0, 0])
    draw_Bracket();

    draw_Bracket();
    
    translate([-50, 0, 0])
    draw_Bracket();
}

module draw_Conduit()
{
    linear_extrude(gdv(EMT_Conduit, "z"))
    circle(d = gdv(EMT_Conduit, "OD"), $fn = 100);
}

module draw_Bracket()
{
    difference()
    {
        {
            linear_extrude(gdv(EMT_Conduit_Bracket, "z"))
            circle(d = gdv(EMT_Conduit_Bracket, "OD"), $fn = 6);            
        }

        draw_Conduit();

        draw_hex_nut_inserts();
    }
}

module draw_hex_nut_inserts()
{
    translate([0, gdv(EMT_Conduit_Bracket, "hex nut X")/2, gdv(EMT_Conduit_Bracket, "hex nut OD")])
    rotate([90, 0, 0])      
    union()
    {
        linear_extrude(gdv(EMT_Conduit_Bracket, "hex nut X"))
        circle(d = gdv(EMT_Conduit_Bracket, "hex nut OD"), $fn = 6);      

        translate([0, 0, -gdv(EMT_Conduit_Bracket, "OD")/6])
        linear_extrude(gdv(EMT_Conduit_Bracket, "OD"))
        circle(d = gdv(EMT_Conduit_Bracket, "hex nut ID"), $fn = 100);             
    }

}