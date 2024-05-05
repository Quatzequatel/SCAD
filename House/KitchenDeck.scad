/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
include <ObjectHelpers.scad>;
use <dictionary.scad>;

House = 
[ "house information",
    ["x", convert_ft2mm(60.25)],
    ["y", convert_ft2mm(70)],
    ["z", convert_ft2mm(20)],
    ["Wall", convert_in2mm(8)],
    ["rotate",[0,0,0]],
    ["move",[convert_ft2mm(15), convert_ft2mm(25), 0]],
    ["color", "Khaki"]
];

Deck = 
[ "Deck information",
    ["x", convert_ft2mm(30)],
    ["y", convert_ft2mm(13)],
    ["z", convert_ft2mm(0.5)],
    ["rotate",[0,0,0]],
    ["move",[gdv(House, "move").x + convert_ft2mm(9.75), convert_ft2mm(25-12), convert_ft2mm(12)]],
    ["color", "SaddleBrown"]
];

Alcove = 
[ "Alcove information",
    ["x", convert_ft2mm(10)],
    ["y", convert_ft2mm(4)],
    ["z", convert_ft2mm(8)],
    ["rotate",[0,0,0]],
    ["move",[gdv(Deck, "move").x +  gdv(Deck, "x") - convert_ft2mm(2), convert_ft2mm(25-4), convert_ft2mm(12)]],
    ["color", "Khaki"]
];

Yard = 
[ "Yard information",
    ["x", convert_ft2mm(100) ],
    ["y", convert_ft2mm(100) ],
    ["z", 1],
    ["rotate", [0,0,0] ],
    ["move", [0, 0, 0] ],
    ["color", "LawnGreen"]
];



build();

module build(args) 
{
    House();
    Deck();
    //Yard();
}

module House()
{

    difference()
    {
        union()
        {
            drawSquareShape(House);
            drawSquareShape(Alcove);            
        }

        drawSquareShape2(
            size =[gdv(House, "x")-convert_ft2mm(1), gdv(House, "y")-convert_ft2mm(1)] , 
            height=gdv(House, "z"), 
            move=[gdv(House, "move").x + convert_ft2mm(0.5), gdv(House, "move").y + convert_ft2mm(0.5), gdv(House, "move").z + convert_ft2mm(0.5)],
            rotate=gdv(House, "rotate"), 
            color=gdv(House, "color"));
    }

}

module Yard()
{
    drawSquareShape(Yard);
}

module Deck() 
{
    drawSquareShape(Deck);
}

// module Alcove() 
// {
//     drawSquareShape(Alcove);
// }

module drawSquareShape(properties)
{
    echo(y = gdv(properties, "y"));
    properties_echo(properties);
    color(gdv(properties, "color"), 0.5)
    rotate(gdv(properties, "rotate"))
    translate(gdv(properties, "move"))
    //move to xy location
    // translate([gdv(properties, "x")/2, gdv(properties, "y")/2])
    linear_extrude(gdv(properties, "z"))
    square(size=[gdv(properties, "x"), gdv(properties, "y")], center=false);
}

module drawSquareShape2(size, height, move, rotate, color)
{
    color(color, 0.5)
    rotate(rotate)
    translate(move)
    //move to xy location
    // translate([gdv(properties, "x")/2, gdv(properties, "y")/2])
    linear_extrude(height)
    square(size=size, center=false);
}

module drawCircleShape(properties)
{
    color(gdv(properties, "color"), 0.5)
    translate(gdv(properties, "move"))
    rotate(gdv(properties, "rotate"))
    translate([gdv(properties, "x")/2, gdv(properties, "y")/2])
    linear_extrude(gdv(properties, "z"))
    circle(d=gdv(properties, "x"), $fn = gdv(properties, "fragments"));
}