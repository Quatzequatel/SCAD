/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
include <ObjectHelpers.scad>;
use <dictionary.scad>;

House1 = 
[
    "house suite information",
    ["x", convert_ft2mm(61)],
    ["y", convert_ft2mm(26)],
    ["z", convert_ft2mm(10)],
    ["Wall", convert_in2mm(8)],
    ["rotate",[0,0,0]],
    ["move",[convert_ft2mm(15), convert_ft2mm(25), convert_ft2mm(10)]],
    ["color", "Khaki"]
];

House2 = 
[
    "house wing information",
    ["x", convert_ft2mm(29)],
    ["y", convert_ft2mm(22)],
    ["z", convert_ft2mm(10)],
    ["Wall", convert_in2mm(8)],
    ["rotate",[0,0,0]],
    ["move",[gdv(House1, "move").x, (gdv(House1, "move").y + gdv(House1, "y")), convert_ft2mm(10)]],
    ["color", "yellow"]
];

House3 = 
[
    "house entry way information",
    ["x", convert_ft2mm(12)],
    ["y", convert_ft2mm(11)],
    ["z", convert_ft2mm(10)],
    ["Wall", convert_in2mm(8)],
    ["rotate",[0,0,0]],
    ["move",[
        gdv(House1, "move").x + convert_ft2mm(5), 
        (gdv(House2, "move").y + gdv(House2, "y")), 
        convert_ft2mm(10)
        ]],
    ["color", "Khaki"]
];

Deck = 
[ "Kitchen Deck information",
    ["x", convert_ft2mm(30)],
    ["y", convert_ft2mm(13)],
    ["z", convert_ft2mm(0.5)],
    ["rotate",[0,0,0]],
    ["move",[gdv(House1, "move").x + convert_ft2mm(9.75), convert_ft2mm(25-12), convert_ft2mm(12)]],
    ["color", "SaddleBrown"]
];

Deck2 = 
[ "Garage Deck information",
    ["x", convert_ft2mm(25)],
    ["y", convert_ft2mm(23)],
    ["z", convert_ft2mm(0.5)],
    ["rotate",[0,0,0]],
    ["move",[
        gdv(House2, "move").x + gdv(House2, "x"), 
        gdv(House1, "move").y + gdv(House1, "y"), 
        convert_ft2mm(12)
        ]],
    ["color", "SaddleBrown"]
];

Garage2 = 
[ "Garage Roof information",
    ["x", convert_ft2mm(23)],
    ["y", convert_ft2mm(14)],
    ["z", convert_ft2mm(0.5)],
    ["rotate",[0,0,0]],
    ["move",[
        gdv(House2, "move").x + gdv(House2, "x"), 
        gdv(Deck2, "move").y + gdv(Deck2, "y"), 
        convert_ft2mm(12)
        ]],
    ["color", "Gainsboro"]
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

Floor1 = 
[
    [ convert_ft2mm(0) ,convert_ft2mm(0) ],
    [ convert_ft2mm(0) ,convert_ft2mm(48)],
    [ convert_ft2mm(5) ,convert_ft2mm(48)],
    [ convert_ft2mm(5) ,convert_ft2mm(59)],
    [ convert_ft2mm(17),convert_ft2mm(59)],
    [ convert_ft2mm(17),convert_ft2mm(48)],
    [ convert_ft2mm(29),convert_ft2mm(48)],
    [ convert_ft2mm(29),convert_ft2mm(26)],
    [ convert_ft2mm(43),convert_ft2mm(26)],
    [ convert_ft2mm(43),convert_ft2mm(24)],
    [ convert_ft2mm(59),convert_ft2mm(24)],
    [ convert_ft2mm(59),convert_ft2mm(20)],
    [ convert_ft2mm(61),convert_ft2mm(20)],
    [ convert_ft2mm(61),convert_ft2mm(0) ],
    [ convert_ft2mm(47),convert_ft2mm(0) ],
    [ convert_ft2mm(47),convert_ft2mm(-4)],
    [ convert_ft2mm(37),convert_ft2mm(-4)],
    [ convert_ft2mm(37),convert_ft2mm(0) ]
];

GarageRoof = 
[
    [ convert_ft2mm(0) ,convert_ft2mm(0) ],
    [ convert_ft2mm(0) ,convert_ft2mm(35) ],
    [ convert_ft2mm(23) ,convert_ft2mm(35) ],
    [ convert_ft2mm(23) ,convert_ft2mm(23) ],
    [ convert_ft2mm(25) ,convert_ft2mm(23) ],
    [ convert_ft2mm(25) ,convert_ft2mm(-2) ],
    [ convert_ft2mm(11) ,convert_ft2mm(-2) ],
    [ convert_ft2mm(11) ,convert_ft2mm(0) ]
];

KitchenDeck = 
[
    [ convert_ft2mm(0) ,convert_ft2mm(0) ],
    [ convert_ft2mm(0) ,convert_ft2mm(13) ],
    [ convert_ft2mm(29) ,convert_ft2mm(13) ],
    [ convert_ft2mm(29) ,convert_ft2mm(9) ],
    [ convert_ft2mm(30) ,convert_ft2mm(9) ],
    [ convert_ft2mm(30) ,convert_ft2mm(0) ],
];

build();

module build(args) 
{
    color("Gainsboro", 0.5)
    applyMove(House1)
    linear_extrude(gdv(House1, "z"))
    polygon(Floor1);

    // House();
    // Deck();
    //Yard();

    color("grey", 1.0)
    union()
    {
        translate([convert_ft2mm(15 + 12 + 5), convert_ft2mm(59 + 26), gdv(Deck, "move").z])
        circle(r = convert_ft2mm(12));

        translate([convert_ft2mm(15 + 12 + 5), convert_ft2mm(59 + 14), gdv(Deck, "move").z])
        square(convert_ft2mm(12));
    }

    //garage roof
    color("SaddleBrown", 0.5)
    translate([convert_ft2mm(15 + 29), convert_ft2mm(25 + 26), gdv(Deck, "move").z])
    linear_extrude(convert_ft2mm(1))
    polygon(GarageRoof);

    color("SaddleBrown", 0.5)
    translate([convert_ft2mm(23), convert_ft2mm(15), gdv(Deck, "move").z])
    linear_extrude(convert_ft2mm(1))
    polygon(KitchenDeck);

}

module House()
{

    // difference()
    // {
        union()
        {
            drawSquareShape(House1);
            drawSquareShape(House2);
            drawSquareShape(House3);
            drawSquareShape(Alcove);            
        }

        // color("blue");
        

        // drawSquareShape2(
        //     size =[gdv(House, "x")-convert_ft2mm(1), gdv(House, "y")-convert_ft2mm(1)] , 
        //     height=gdv(House, "z"), 
        //     move=[gdv(House, "move").x + convert_ft2mm(0.5), gdv(House, "move").y + convert_ft2mm(0.5), gdv(House, "move").z + convert_ft2mm(0.5)],
        //     rotate=gdv(House, "rotate"), 
        //     color=gdv(House, "color"));
    // }
}

module Yard()
{
    drawSquareShape(Yard);
}

module Deck() 
{
    drawSquareShape(Deck);
    drawSquareShape(Deck2);
    drawSquareShape(Garage2);
}



//-----------------------------------------------------
// Utilities Below
//-----------------------------------------------------
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

///
// drawSquareShape2: when difference() with drawSquareShape will create walls.
///
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