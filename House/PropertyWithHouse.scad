/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
include <ObjectHelpers.scad>;
use <dictionary.scad>;

/*
    Edits:
    1. Refactor house into

*/

function convert_a_ft2mm(args) = [convert_ft2mm(args.x), convert_ft2mm(args.y), convert_ft2mm(args.z)];

/*
    What to show in view
*/
show_cudesac = 0;

z_Base = 0;
firstFloor_ft = 10;
firstFlorLabels_ft = firstFloor_ft + 1;
kitchenDeck_ft = 12;
kitchenDeck_lablels_ft = kitchenDeck_ft + 1;
garage_deck_ft = 16;
garage_deck_lables_ft = garage_deck_ft + 1;
z_FirstFloor = convert_ft2mm(firstFloor_ft);
z_KitchenDeck = convert_ft2mm(kitchenDeck_ft);

SiteMap = 
[
    [ convert_ft2mm(0) ,convert_ft2mm(0) ],
    [ convert_ft2mm(182) ,convert_ft2mm(0) ],
    [ convert_ft2mm(202.57) ,convert_ft2mm(-36.89) ],
    [ convert_ft2mm(175.87) ,convert_ft2mm(-87.5) ],
    [ convert_ft2mm(0) ,convert_ft2mm(-103.24) ],
];


//The whole first floor layout
Main_Floor = 
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

//The whole first floor layout
First_Floor = 
[
    [ convert_ft2mm(0) ,convert_ft2mm(0) ],
    [ convert_ft2mm(0) ,convert_ft2mm(26)],
    // [ convert_ft2mm(5) ,convert_ft2mm(48)],
    // [ convert_ft2mm(5) ,convert_ft2mm(59)],
    // [ convert_ft2mm(17),convert_ft2mm(59)],
    // [ convert_ft2mm(17),convert_ft2mm(48)],
    // [ convert_ft2mm(29),convert_ft2mm(48)],
    // [ convert_ft2mm(29),convert_ft2mm(26)],
    [ convert_ft2mm(43),convert_ft2mm(26)],
    [ convert_ft2mm(43),convert_ft2mm(24)],
    [ convert_ft2mm(59),convert_ft2mm(24)],
    [ convert_ft2mm(59),convert_ft2mm(20)],
    [ convert_ft2mm(61),convert_ft2mm(20)],
    [ convert_ft2mm(61),convert_ft2mm(0) ]
    // [ convert_ft2mm(47),convert_ft2mm(0) ],
    // [ convert_ft2mm(47),convert_ft2mm(-4)],
    // [ convert_ft2mm(37),convert_ft2mm(-4)],
    // [ convert_ft2mm(37),convert_ft2mm(0) ]
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
    ["z", convert_ft2mm(firstFloor_ft)],
    ["Wall", convert_in2mm(8)],
    ["rotate",[0,0,0]],
    ["move",[convert_ft2mm(15), convert_ft2mm(25), convert_ft2mm(firstFlorLabels_ft)]],
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

font_size = 1000;
font_color = "black";

build();

module build(args) 
{
    difference()
    {
        site_map();
        if (show_cudesac == 1) { culdesac(); echo(str("show_cudesac = 1"));}

    }

    if (show_cudesac == 1) { culdesac(); echo(str("show_cudesac = 1"));}
    easement();

    translate([convert_ft2mm(60), (SiteMap[4].y - convert_ft2mm(0)) * -1, 0])    
    rotate([0, 0, -90]) 
    union()
    {
        main_floor_draw();
        first_floor_draw();
        front_porch_draw();
        garage_deck_draw();
        kitchen_deck_draw();

    }

    labels();   

}

module labels(args)
{
    kitchenDeckLabels();
    house_Lables();
    garage_Roof_Lables();
    front_entryway_labels();
}

module kitchenDeckLabels(args)
{
    font_size = 1000;
    font_color = "black";

    color(font_color, 0.5)
    translateInFt([75, 82, kitchenDeck_lablels_ft])
    text("13'", font_size);

    color(font_color, 0.5)
    translateInFt([70, 82-20, kitchenDeck_lablels_ft])
    rotate([0,0,90])
    text("30'", font_size);

    color(font_color, 0.5)
    translateInFt([73, 82 - 37, kitchenDeck_lablels_ft])
    text("9'", font_size);
}

module front_entryway_labels(args) 
{
    color(font_color, 1)
    translateInFt([75 + 62, 90 - 17, firstFlorLabels_ft])
    text("11'", font_size);

    color(font_color, 1)
    translateInFt([75 + 75, 90 - 17, firstFlorLabels_ft])
    rotate([0, 0, 90])     
    text("12'", font_size);

    color(font_color, 1)
    translateInFt([75 + 57, 90 - 28, firstFlorLabels_ft])
    rotate([0, 0, 90])     
    text("12'", font_size);
    
}

module house_Lables(args) 
{
    color(font_color, 0.5)
    translateInFt([75 + 30, 90-1.5, firstFloor_ft])
    text("48'", font_size);

    color(font_color, 1)
    translateInFt([75 + 57, 90 - 7, firstFloor_ft])
    rotate([0, 0, 90])     
    text("5'", font_size);

    // color(font_color, 1)
    // translateInFt([75 + 75, 90 - 17, firstFloor_ft])
    // rotate([0, 0, 90])     
    // text("12'", font_size);

    color(font_color, 0.5)
    translateInFt([75 + 62, 90 - 6.5, firstFloor_ft])
    text("11'", font_size);


    color(font_color, 0.5)
    translateInFt([75 + 43, 90 - 30, firstFloor_ft])
    text("22'", font_size);

    color(font_color)
    translateInFt([110, 50, firstFloor_ft])
    rotate([0, 0, 90])     
    text("14'", font_size);

    color(font_color)
    translateInFt([108, 34, firstFloor_ft])
    rotate([0, 0, 90])     
    text("16'", font_size);

    color(font_color)
    translateInFt([105, 30, firstFloor_ft])
    // rotate([0, 0, 90])     
    text("4'", font_size);

    color(font_color)
    translateInFt([93, 28, firstFloor_ft])
    // rotate([0, 0, 90])     
    text("20'", font_size);

    color(font_color)
    translateInFt([90, 31, firstFloor_ft])
    rotate([0, 0, 90])     
    text("14'", font_size);

    color(font_color)
    translateInFt([85, 43, firstFloor_ft])
    rotate([0, 0, 90])     
    text("10'", font_size);

    color(font_color)
    translateInFt([90, 65, firstFloor_ft])
    rotate([0, 0, 90])     
    text("37'", font_size);
}

module garage_Roof_Lables(args) 
{
    font_size = 1000;
    font_color = "black";

    color(font_color)
    translateInFt([125, 55, kitchenDeck_ft])
    // rotate([0, 0, 90])     
    text("33'", font_size);

    color(font_color)
    translateInFt([146, 45, kitchenDeck_ft])
    rotate([0, 0, 90])     
    text("23'", font_size);

    color(font_color)
    translateInFt([137, 37, kitchenDeck_ft])
    // rotate([0, 0, 90])     
    text("12'", font_size);

    color(font_color)
    translateInFt([120, 35, kitchenDeck_ft])
    // rotate([0, 0, 90])     
    text("23'", font_size);

    color(font_color)
    translateInFt([125, 55, kitchenDeck_ft])
    // rotate([0, 0, 90])     
    text("33'", font_size);
}



module easement(args)
{
    line_size = 75;

    color( font_color )
    translateInFt([2, 150/2, 1.2])
    rotate([0,0,-90])
    text("<- Boundry 103.24' ->", font_size);

    color( font_color )
    translateInFt([11, 150/2, 1.2])
    rotate([0,0,-90])
    text("Easement 12'", font_size);

    color( font_color )
    translate([0, 0, convert_ft2mm(1.2)])
    line([convert_ft2mm(12), convert_ft2mm(1.6), 0], [convert_ft2mm(12), convert_ft2mm(103.24), 0], line_size);

    color( font_color )
    translateInFt([175/2, 9, 1.2])
    rotate([0, 0, 5])
    text("<- Boundry 175.87' ->", font_size);

    color( font_color )
    translateInFt([175/2, 16, 1.2])
    rotate([0, 0, 5])
    text("Easement 10'", font_size);

    color( font_color )
    line(convert_a_ft2mm([0.5,10,0]), convert_a_ft2mm([174, 15.35 + 10, 0]), line_size);

    color( font_color )
    translateInFt([175/2, 99, 1.2])
    text("<- Boundry 181.67' ->", font_size);

    color( font_color )
    translateInFt([178, 102, 1.2])
    rotate([0, 0, -60])
    text("<- Boundry 42.40' ->", font_size);

    //culdesac
    color( font_color )
    translateInFt([0, 0, 1.2])
    // !rotate([0, 0, -60])
    line(convert_a_ft2mm([224.5, 23, 0]), convert_a_ft2mm([202, 67, 0]), line_size);

    color( font_color )
    translateInFt([207, 45, 1.2])
    rotate([0, 0, -62])
    text("r = 50.00", font_size);

}

module site_map(args)
{
    // translate([0, SiteMap[4].y * -1, 0])
    translateInFt([0, 103.24, 0])
    color("PaleGreen", 1)
    linear_extrude(convert_in2mm(0.5))
    difference()
    {
        polygon(SiteMap);
        offset(delta= convert_ft2mm(-0.5)) polygon(SiteMap);
    }
}

module culdesac(args)
{
    // translate([convert_ft2mm(224.5), convert_ft2mm(23), convert_ft2mm(1.2)])
    translateInFt([224.5, 23, -1])
    color("lightgray", 1)
    linear_extrude(convert_ft2mm(0.1))
    // translate([0, 0, convert_ft2mm(-2)])
    circle($fn = 100, convert_ft2mm(50));
}


module main_floor_draw()
{
    color("LemonChiffon", 1)
    translateInFt([15, 25, 0])
    linear_extrude(gdv(House1, "z"))
    difference()
    {
        polygon(First_Floor);
        offset(delta= convert_ft2mm(-0.5)) polygon(First_Floor);
    }
}

module first_floor_draw()
{
    color("LemonChiffon", 1)
    applyMove(House1)
    linear_extrude(gdv(House1, "z"))
    difference()
    {
        polygon(Main_Floor);
        offset(delta= convert_ft2mm(-0.5)) polygon(Main_Floor);
    }
}

module front_porch_draw()
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

    color("LightYellow", 1)
    translateInFt([15 + 12 + 5 - 11.5, 59 + 14, 12])
    linear_extrude(convert_ft2mm(1))
    square(convert_ft2mm(11), convert_ft2mm(12));    
}

module garage_deck_draw()
{
    //garage roof
    color("SaddleBrown", 0.5)
    // translate([convert_ft2mm(15 + 29), convert_ft2mm(25 + 26), gdv(Deck, "move").z])
    translateInFt([15 + 29, 25 + 26, garage_deck_ft])
    linear_extrude(convert_ft2mm(1))
    polygon(GarageRoof);    
}

module kitchen_deck_draw()
{
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