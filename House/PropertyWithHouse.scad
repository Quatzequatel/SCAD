/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
include <ObjectHelpers.scad>;
use <dictionary.scad>;

function convert_a_ft2mm(args) = [convert_ft2mm(args.x), convert_ft2mm(args.y), convert_ft2mm(args.z)];



SiteMap = 
[
    [ convert_ft2mm(0) ,convert_ft2mm(0) ],
    [ convert_ft2mm(182) ,convert_ft2mm(0) ],
    [ convert_ft2mm(202.57) ,convert_ft2mm(-36.89) ],
    [ convert_ft2mm(175.87) ,convert_ft2mm(-87.5) ],
    [ convert_ft2mm(0) ,convert_ft2mm(-103.24) ],
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
    [ convert_ft2mm(0) ,convert_ft2mm(36) ],
    [ convert_ft2mm(23) ,convert_ft2mm(36) ],
    [ convert_ft2mm(23) ,convert_ft2mm(23) ],
    [ convert_ft2mm(25) ,convert_ft2mm(23) ],
    [ convert_ft2mm(25) ,convert_ft2mm(-2) ],
    [ convert_ft2mm(14) ,convert_ft2mm(-2) ],
    [ convert_ft2mm(14) ,convert_ft2mm(0) ]
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

Deck = 
[ "Kitchen Deck information",
    ["x", convert_ft2mm(30)],
    ["y", convert_ft2mm(13)],
    ["z", convert_ft2mm(0.5)],
    ["rotate",[0,0,0]],
    ["move",[gdv(House1, "move").x + convert_ft2mm(9.75), convert_ft2mm(25-12), convert_ft2mm(12)]],
    ["color", "SaddleBrown"]
];

build();

module build(args) 
{
    difference()
    {
        site_map();
        culdesac();
    }

    culdesac();
    easement();

    house();

}

module house(args)
{
    translate([convert_ft2mm(60), (SiteMap[4].y - convert_ft2mm(0)) * -1, 0])    
    rotate([0,0,-90])
    union()
    {
        house_poly();
        front_porch();
        decks();
    }
}

module easement(args)
{
    color("black", 0.5)
    translate([0, 0, convert_ft2mm(1.2)])
    line([convert_ft2mm(12), 0, 0], [convert_ft2mm(12), convert_ft2mm(103.24), 0], 100);

    color("black", 0.5)
    // translate([0, 0, convert_ft2mm(1.2)])
    // line([0, convert_ft2mm(10), 0], [convert_ft2mm(180.87), convert_ft2mm(15.35 + 10), 0], 100);
    line(convert_a_ft2mm([0,10,0]), convert_a_ft2mm([174, 15.35 + 10, 0]), 100);

    color("black", 0.5)
    // translate([convert_ft2mm(175/2), convert_ft2mm(12), convert_ft2mm(1.2)])
    translateInFt([175/2, 10, 1.2])
    rotate([0, 0, 5])
    text("Easement 10'", 1500);

    color("black", 0.5)
    // translate([convert_ft2mm(5), convert_ft2mm(150/2), convert_ft2mm(1.2)])
    translateInFt([5, 150/2, 1.2])
    rotate([0,0,-90])
    text("Easement 12'", 1500);

}

module site_map(args)
{
    // translate([0, SiteMap[4].y * -1, 0])
    translateInFt([0, 103.24, 0])
    color("PaleGreen", 0.5)
    linear_extrude(convert_in2mm(0.5))
    polygon(SiteMap);
}

module culdesac(args)
{
    // translate([convert_ft2mm(224.5), convert_ft2mm(23), convert_ft2mm(1.2)])
    translateInFt([224.5, 23, -1])
    color("lightgray", 1)
    linear_extrude(convert_ft2mm(2))
    // translate([0, 0, convert_ft2mm(-2)])
    circle($fn = 100, convert_ft2mm(50));
}

module house_poly(args) 
{
    color("Gainsboro", 0.5)
    applyMove(House1)
    linear_extrude(gdv(House1, "z"))
    difference()
    {
        polygon(Floor1);
        offset(delta= convert_ft2mm(-0.5)) polygon(Floor1);
    }
    // polygon(Floor1);
}

module front_porch(args) 
{
    color("grey", 1.0)
    union()
    {
        // translate([convert_ft2mm(15 + 12 + 5), convert_ft2mm(59 + 26), gdv(Deck, "move").z])
        translateInFt([15+12+5, 59 + 26, 12])
        circle(r = convert_ft2mm(12));

        // translate([convert_ft2mm(15 + 12 + 5), convert_ft2mm(59 + 14), gdv(Deck, "move").z])
        translateInFt([15 + 12 + 5, 59 + 14, 12])
        square(convert_ft2mm(12));
    }
}

module decks()
{
    //garage roof
    color("SaddleBrown", 0.5)
    // translate([convert_ft2mm(15 + 29), convert_ft2mm(25 + 26), gdv(Deck, "move").z])
    translateInFt([15 + 29, 25 + 26, 12])
    linear_extrude(convert_ft2mm(1))
    polygon(GarageRoof);

    //kitchen
    color("SaddleBrown", 0.5)
    // translate([convert_ft2mm(23), convert_ft2mm(15), gdv(Deck, "move").z])
    translateInFt([23, 12, 12])
    linear_extrude(convert_ft2mm(1))
    polygon(KitchenDeck);
}

module translateInFt(args)
{
    translate([convert_ft2mm(args.x), convert_ft2mm(args.y), convert_ft2mm(args.z)])
    children();
}

module line(start, end, thickness = 1) 
{
    hull() 
    {
        translate(start) sphere(thickness);
        translate(end) sphere(thickness);
    }
}