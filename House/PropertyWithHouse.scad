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
    2. added placement lines
    3. added green house
    4. added toolshed
    5. added driveway
    6. added walkway.
    7. need to add patio
    8. finish walkway
    9. deminsions for sundeck, drive way, walk way, patio,
    10. Adding Setbacks, 20 ft for front yard, 10 ft for back yard, 5 for side yard.
    11. Added z_ globals
    12. Added scale_large to include a XY scale graph.
    13. used globals instead of literals.

*/

function convert_a_ft2mm(args) = [convert_ft2mm(args.x), convert_ft2mm(args.y), convert_ft2mm(args.z)];

/*
    What to show in view
*/
show_cudesac = 1;
show_reference_lines = 0;

z_Base = 0;
z_easement = 1.2;
z_driveway = 0.1;
z_culdesac = 1.0;
firstFloor_ft = 10;
firstFlorLabels_ft = firstFloor_ft + 4;
kitchenDeck_ft = 12;
kitchenDeck_lablels_ft = kitchenDeck_ft + 1;
garage_deck_ft = 16;
garage_deck_lables_ft = garage_deck_ft + 1;
z_FirstFloor = convert_ft2mm(firstFloor_ft);
z_KitchenDeck = convert_ft2mm(kitchenDeck_ft);
x_moveHouse = 16.4;
y_move_House = 12.75;

    line_size = 75;


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

GreenHouse = 
[
    [convert_ft2mm(0) , convert_ft2mm(0)],
    [ convert_ft2mm(0)    , convert_ft2mm(16)],
    [convert_ft2mm(11.25) , convert_ft2mm(16)],
    [convert_ft2mm(11.25) , convert_ft2mm(10.5)],
    [convert_ft2mm(15.25) , convert_ft2mm(10.5)],
    [convert_ft2mm(15.25) , convert_ft2mm(5.5) ],
    [convert_ft2mm(11.25) , convert_ft2mm(5.5) ],
    [convert_ft2mm(11.25) , convert_ft2mm(0)   ],
    [convert_ft2mm(0) , convert_ft2mm(0) ],
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

font_size = 500;
font_color = "black";
font_placement_color = "blue";


build();

//puts a foot scale on X and Y axis for point of reference.
module scale_large(size = 24, increment = convert_in2mm(1), fontsize = 12)
{
  if($preview)
  {
    for (i=[0:size]) 
    {
        translate([f(i, increment), -increment/2, 0])
        color("black", 0.5)
        union()
        {
            text(text = str(i * 10, " ft"), size = fontsize);
            rotate([90,0])
            cylinder(r=convert_in2mm(1), h=f(1, increment/2), center=true);
        }

        translate([-increment/2, f(i, increment), 0])
        color("black", 0.5)
        union()
        {
            text(text = str(i * 10, " ft"), size = fontsize);
            rotate([0,90])
            cylinder(r=convert_in2mm(1), h=f(1, increment/2), center=true);
        }   
    }     
  }
}

module build(args) 
{
    translateInFt([0,0,z_easement])
    scale_large(size = 22, increment = convert_in2mm(120), fontsize = 500);

    difference()
    {
        site_map();
        // if (show_cudesac == 1) { culdesac(); echo(str("show_cudesac = 1"));}
    }

    if (show_cudesac == 1) { culdesac(); echo(str("show_cudesac = 1"));}
    easement();

    translateInFt([0, 7.5,0])
    translate([convert_ft2mm(60 + x_moveHouse), ((SiteMap[4].y + convert_ft2mm(0)) * -1), 0])    
    rotate([0, 0, -90]) 
    //draw the house
    union()
    {
        main_floor_draw();
        first_floor_draw();
        front_porch_draw();
        garage_deck_draw();
        kitchen_deck_draw();
    }

    Draw_greenhouse();
    draw_toolShed();
    draw_driveway();
    draw_walkway();
    draw_patio();
    draw_setbacks();
    // draw_storage();

    translateInFt([x_moveHouse, 7.5, 0])
    labels();   

    if (show_reference_lines == 1) House_Placement_Lines();

}

module labels(args)
{
    
    union()
    {
        kitchenDeckLabels();
        house_Lables();
        garage_Roof_Lables();
        front_entryway_labels();        
        labels_for_large();
    }

}

module kitchenDeckLabels(args)
{
    // font_size = 1000;
    font_color = "black";

    color(font_color, 1.0)
    translateInFt([76, 78, kitchenDeck_lablels_ft])
    text("13'", font_size);

    color(font_color, 1.0)
    translateInFt([74, 64, kitchenDeck_lablels_ft])
    rotate([0,0,90])
    text("30'", font_size);

    color(font_color, 1.0)
    translateInFt([76, 82 - 31.5, kitchenDeck_lablels_ft])
    text("9'", font_size);
}

module front_entryway_labels(args) 
{
    color(font_color, 1)
    translateInFt([137, 73, firstFlorLabels_ft])
    text("11'", font_size);

    color(font_color, 1)
    translateInFt([146, 75, firstFlorLabels_ft])
    rotate([0, 0, 90])     
    text("12'", font_size);

    color(font_color, 1)
    translateInFt([132, 64, firstFlorLabels_ft])
    rotate([0, 0, 90])     
    text("12'", font_size);
    
}

module house_Lables(args) 
{
    // color(font_color, 0.5)
    // translateInFt([75 + 30, 90-1.5, firstFloor_ft])
    // text("<-48'->", font_size);

    color(font_color, 1)
    translateInFt([132, 85, firstFloor_ft])
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
    translateInFt([108, 37, firstFloor_ft])
    rotate([0, 0, 90])     
    text("16'", font_size);

    color(font_color)
    translateInFt([106.5, 30, firstFloor_ft])
    // rotate([0, 0, 90])     
    text("4'", font_size);

    color(font_color)
    translateInFt([93, 28, firstFloor_ft])
    // rotate([0, 0, 90])     
    text("20'", font_size);

    color(font_color)
    translateInFt([88, 33, firstFloor_ft])
    rotate([0, 0, 90])     
    text("14'", font_size);

    color(font_color)
    translateInFt([88, 44.5, firstFloor_ft])
    rotate([0, 0, 90])     
    text("10'", font_size);

    color(font_color)
    translateInFt([88, 65, firstFloor_ft])
    rotate([0, 0, 90])     
    text("37'", font_size);
}

module garage_Roof_Lables(args) 
{
    // font_size = 1000;
    font_color = "black";

    color(font_color)
    translateInFt([125, 57, garage_deck_lables_ft])
    // rotate([0, 0, 90])     
    text("33'", font_size);

    color(font_color)
    translateInFt([146, 45, garage_deck_lables_ft])
    rotate([0, 0, 90])     
    text("23'", font_size);

    color(font_color)
    translateInFt([137, 37, garage_deck_lables_ft])
    // rotate([0, 0, 90])     
    text("12'", font_size);

    color(font_color)
    translateInFt([120, 35, garage_deck_lables_ft])
    // rotate([0, 0, 90])     
    text("23'", font_size);

}

module labels_for_large(args)
{
    color(font_color)
    translateInFt([98, 28, firstFloor_ft])
    rotate([0, 0, 90])     
    text("<- - - - - -- - - - - - - - - - - - - - 61' - - - - - - - - - - - - - - - - - - - ->", font_size);

    color(font_color)
    translateInFt([85, 84, firstFloor_ft])
    // rotate([0, 0, 90])     
    text("<- - - - - - - - - - - - - - - - 48' - - - - - - - -- - - - - - -->", font_size);        

    color(font_color)
    translateInFt([125, 10, firstFloor_ft])
    rotate([0, 0, 90])     
    text("<- - - - - - - -25'- - - - - - ->", font_size);        

    color(font_color)
    translateInFt([100, 15, firstFloor_ft])
    // rotate([0, 0, 90])     
    text("<- - - - - - - - - - - - - - - - - - - - - - - - 67' - - - -- - - - - - - - - - - - - - - ->", font_size);        

}

module easement(args)
{

    color( font_color )
    translateInFt([0.5, 150/2, z_easement])
    rotate([0,0,-90])
    text("<-- Boundry 103.24' -->", font_size);

    color( font_color )
    translateInFt([12.5, 150/2, z_easement])
    rotate([0,0,-90])
    text("<-- Easement 12' -->", font_size);

    color( font_color )
    translateInFt([0, 0, z_easement])
    line([convert_ft2mm(12), convert_ft2mm(1.6), 0], [convert_ft2mm(12), convert_ft2mm(103.24), 0], line_size);

    color( font_color )
    translateInFt([175/2, 8, z_easement])
    rotate([0, 0, 5])
    text("<-- Boundry 175.87' -->", font_size);

    //Easement text
    color( font_color )
    translateInFt([175/2, 16, z_easement])
    rotate([0, 0, 5])
    text("<-- Easement 10' -->", font_size);
    //Easement line
    translateInFt([0, 0, z_easement])
    color( font_color )
    line(convert_a_ft2mm([0.5,10,0]), convert_a_ft2mm([180, 15.35 + 10, 0]), line_size);

    color( font_color )
    translateInFt([175/2, 99, z_easement])
    text("<- Boundry 181.67' ->", font_size);

    color( font_color )
    translateInFt([178, 102, z_easement])
    rotate([0, 0, -60])
    text("<- Boundry 42.40' ->", font_size);

    //culdesac
    color( font_color, 1.0 )
    translateInFt([0, 0, z_easement])
    // !rotate([0, 0, -60])
    line(convert_a_ft2mm([224.5, 23, 0]), convert_a_ft2mm([202, 67, 0]), line_size);

    color( font_color )
    translateInFt([207, 45, z_easement])
    rotate([0, 0, -62])
    text("r = 50.00", font_size);   
}

module House_Placement_Lines(args)
{
    z_placement_move = 10;
    y_garage_move = 12.75;
    //line show porch to boarder
    color(font_placement_color)
    translateInFt([0, 0, z_placement_move])
    line(convert_a_ft2mm([195.5, 78.5, 0]), convert_a_ft2mm([195.5-22, 78.5, 0]), line_size);

    //line show garage to boarder
    color(font_placement_color)
    translateInFt([0, 0, z_placement_move])
    line(convert_a_ft2mm([140, y_garage_move, 0]), convert_a_ft2mm([140, y_garage_move + 29, 0]), line_size);

    //line to show distance from north board to house.
    color(font_placement_color)
    translateInFt([0, 0, z_placement_move])
    line(convert_a_ft2mm([140, 102.6, 0]), convert_a_ft2mm([140, 102.6-6.667, 0]), line_size);

    //line from fence to west wall of house
    color(font_placement_color)
    translateInFt([0, 0, z_placement_move])
    line(convert_a_ft2mm([1, 78.5, 0]), convert_a_ft2mm([100.334, 78.5, 0]), line_size);

    //other lines
    //reference point driveway
    color(font_placement_color)
    translateInFt([0, 0, 0])
    line(convert_a_ft2mm([129.6, 38, 0]), convert_a_ft2mm([129.6-4, 38, 0]), line_size);  

    //line to show distance house to walkway.
    color(font_placement_color)
    translateInFt([0, 0, 0])
    line(convert_a_ft2mm([169, 55, 0]), convert_a_ft2mm([169-5.5, 55, 0]), line_size);

    //reference point for patio.
    color(font_placement_color)
    translateInFt([0, 0, 0])
    line(convert_a_ft2mm([101, 35, 0]), convert_a_ft2mm([101, 35+3, 0]), line_size);
}

module site_map(args)
{
    // translate([0, SiteMap[4].y * -1, 0])
    translateInFt([0, 103.24, z_easement])
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
    // translate([convert_ft2mm(224.5), convert_ft2mm(23), convert_ft2mm(z_easement)])
    translateInFt([228.5, 20, z_culdesac])
    color("lightgray", 1.0)
    linear_extrude(convert_ft2mm(0.00001))
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

    //color in the alcove
    color("white", 1)
    translateInFt([52, 21.5, firstFloor_ft])
    linear_extrude(convert_in2mm(6))
    square([convert_ft2mm(10), convert_ft2mm(4)]);

    //alcove lable
    color(font_color)
    translateInFt([61, 23, firstFloor_ft + 1])
    rotate([0, 0, 90])     
    text("4'", font_size);

}

module front_porch_draw()
{
    color("Gainsboro", 1)
    union()
    {
        // translate([convert_ft2mm(15 + 12 + 5), convert_ft2mm(59 + 26), gdv(Deck, "move").z])
        translateInFt([15+12+5, 59 + 26, 12])
        linear_extrude(convert_ft2mm(1))
        circle(r = convert_ft2mm(12));

        // translate([convert_ft2mm(15 + 12 + 5), convert_ft2mm(59 + 14), gdv(Deck, "move").z])
        translateInFt([15 + 12 + 5, 59 + 14, 12])
        linear_extrude(convert_ft2mm(1))
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
    color("SaddleBrown", 0.2)
    // translate([convert_ft2mm(15 + 29), convert_ft2mm(25 + 26), gdv(Deck, "move").z])
    translateInFt([15 + 29, 25 + 26, garage_deck_ft])
    linear_extrude(convert_ft2mm(1))
    polygon(GarageRoof);    
    
    //lable
    color(font_color, 1.0)
    translateInFt([57, 60, garage_deck_ft + 5])
    rotate([0, 0, 90])
    text("Garage Deck", font_size); 
}

module kitchen_deck_draw()
{
    //kitchen
    color("SaddleBrown", 0.2)
    // translate([convert_ft2mm(23), convert_ft2mm(15), gdv(Deck, "move").z])
    translateInFt([23, 12, 12])
    linear_extrude(convert_ft2mm(1))
    polygon(KitchenDeck);    

    //lable
    color(font_color, 1.0)
    translateInFt([32, 19, garage_deck_ft + 5])
    // rotate([0, 0, 90])
    text("Kitchen Deck", font_size);     
}

module Draw_greenhouse()
{
    greenhouse_placement = [13.667, 29.5, 0];
    //Green house
    color("LightSlateGray", 0.5)
    // translate([convert_ft2mm(23), convert_ft2mm(15), gdv(Deck, "move").z])
    translateInFt(greenhouse_placement)
    linear_extrude(convert_ft2mm(1))
    //rotate([0, 0, -90]) 
    polygon(GreenHouse);         

    //label
    color(font_color)
    translateInFt([greenhouse_placement.x, greenhouse_placement.y + 18, 5])
    text("Green House", font_size);    
    
    //length
    color(font_color)
    translateInFt([greenhouse_placement.x, greenhouse_placement.y + 8, 5])
    text("16'", font_size);
    
    //width
    color(font_color)
    translateInFt([greenhouse_placement.x + 3, greenhouse_placement.y + 14, 5])
    text("11'3''", font_size);

    color(font_color)
    translateInFt([greenhouse_placement.x + 3, greenhouse_placement.y + 0.5, 5])
    text("11'3''", font_size);
    
    //short wall 
    color(font_color)
    translateInFt([greenhouse_placement.x + 11, greenhouse_placement.y + 2, 5])
    text("5'6''", font_size);

    color(font_color)
    translateInFt([greenhouse_placement.x + 11, greenhouse_placement.y + 12, 5])
    text("5'6''", font_size);

    //door
    color(font_color)
    translateInFt([greenhouse_placement.x + 15.5, greenhouse_placement.y + 7, 5])
    text("5'", font_size);

    color(font_color)
    translateInFt([greenhouse_placement.x + 12, greenhouse_placement.y + 8.5, 5])
    text("4'", font_size);

    color(font_color)
    translateInFt([greenhouse_placement.x + 12, greenhouse_placement.y + 5.5, 5])
    text("4'", font_size);

}

module draw_toolShed(args) 
{
    color("LightSlateGray", 0.5)
    translateInFt([40, 103.24-9.5, 0])
    square(size=[convert_in2mm(91), convert_in2mm(91)], center=true);

    //toolshed
    color(font_color)
    translateInFt([35, 99, 5])
    text("Tool Shed", font_size);

    color(font_color)
    translateInFt([44, 94, 5])
    text("7'7''", font_size);

    color(font_color)
    translateInFt([38, 89, 5])
    text("7'7''", font_size);

}

module draw_driveway(args)
{
    local_color_alpha = 0.2;
    //section 1
    color("LightSlateGray", local_color_alpha)
    translateInFt([116.6 + 6.6, 23.6, z_driveway])
    square(size=[convert_ft2mm(13), convert_ft2mm(12)], center=true);

    //section 2
    color("LightSlateGray", local_color_alpha)
    translateInFt([129.7 + 6.6, 35.7, z_driveway])
    square(size=[convert_ft2mm(13), convert_ft2mm(12)], center=true);

    color("LightSlateGray", local_color_alpha)
    translateInFt([129.7 + 6.6, 23.6, z_driveway])
    square(size=[convert_ft2mm(13), convert_ft2mm(12)], center=true);

    //section 3
    small_garage = 
    [
        [convert_ft2mm(0) ,convert_ft2mm(0)],
        [convert_ft2mm(0) ,convert_ft2mm(13.75)],
        [convert_ft2mm(12.9) ,convert_ft2mm(13.75)],
        // [convert_ft2mm(9.5) ,convert_ft2mm(6)],
        // [convert_ft2mm(12.9) ,convert_ft2mm(6)],
        [convert_ft2mm(12.9) ,convert_ft2mm(0)],
        [convert_ft2mm(0) ,convert_ft2mm(0)],
    ];
    
    // color("LightSlateGray", local_color_alpha)
    // translateInFt([149.4, 35.7, z_driveway])
    // square(size=[convert_ft2mm(13), convert_ft2mm(12)], center=true);

    color("LightSlateGray", local_color_alpha)
    translateInFt([143.0, 29.8, z_driveway])
    polygon(small_garage);    

    color("LightSlateGray", local_color_alpha)
    translateInFt([149.4, 23.6, z_driveway])
    square(size=[convert_ft2mm(13), convert_ft2mm(12)], center=true);

    //section 4
    walkway_section = 
    [
        [convert_ft2mm(0) ,convert_ft2mm(0)],
        [convert_ft2mm(0) ,convert_ft2mm(13.75)],
        [convert_ft2mm(7.5) ,convert_ft2mm(13.75)],
        [convert_ft2mm(7.8) ,convert_ft2mm(6)],
        [convert_ft2mm(13) ,convert_ft2mm(6)],
        [convert_ft2mm(13) ,convert_ft2mm(0)],
        [convert_ft2mm(0) ,convert_ft2mm(0)],
    ];

    color("LightSlateGray", local_color_alpha)
    // translateInFt([156.3 + 6.2, 35.7, z_driveway])
    // square(size=[convert_ft2mm(13), convert_ft2mm(12)], center=true);
    translateInFt([156.0, 29.8, z_driveway])
    polygon(walkway_section);

    

    color("LightSlateGray", local_color_alpha)
    translateInFt([156.3 + 6.2, 23.6, z_driveway])
    square(size=[convert_ft2mm(13), convert_ft2mm(12)], center=true);    

    //section 5
    color("LightSlateGray", local_color_alpha)
    translateInFt([175.2, 25.6, z_driveway])
    square(size=[convert_ft2mm(12), convert_ft2mm(16)], center=true);       
  
}

module draw_walkway(args)
{
    local_color_alpha = 0.2;
    //main section
    color("LightSlateGray", local_color_alpha)
    translateInFt([172.2, 51.8, z_Base])
    square(size=[convert_ft2mm(6), convert_ft2mm(20)], center=true);

    //stairs to porch
    color("LightSlateGray", local_color_alpha)
    translateInFt([170, 66, z_Base])
    rotate([0, 0, 24])
    square(size=[convert_ft2mm(4.5), convert_ft2mm(10.5)], center=true);

    //connect main to driveway
    color("LightSlateGray", local_color_alpha)
    translateInFt([172.2, 37.7, z_Base])
    square(size=[convert_ft2mm(6), convert_ft2mm(8)], center=true);

    //lable
    color(font_color, 1.0)
    translateInFt([165, 78, kitchenDeck_lablels_ft])
    text("Porch", font_size); 
}

module draw_patio(args)
{
    local_color_alpha = 0.2;
    //draw patio
    color("LightSlateGray", local_color_alpha)
    translateInFt([95.4, 48.3, 0])
    square(size=[convert_ft2mm(12), convert_ft2mm(20.25)], center=true);

    //add labels
    color(font_color, 1.0)
    translateInFt([90, 47, kitchenDeck_lablels_ft])
    text("20'", font_size);

    color(font_color, 1.0)
    translateInFt([94, 39, kitchenDeck_lablels_ft])
    text("12'", font_size);    

    //caption
    color(font_color, 1.0)
    translateInFt([93, 45, kitchenDeck_lablels_ft])
    text("Patio", font_size);    
}

module draw_setbacks(args)
{
    //10. Adding Setbacks, 20 ft for front yard, 10 ft for back yard, 5 for side yard.
    local_line_size = 25;


    //north side yard
    color( "LightSlateGray" )
    translateInFt([1, 103.24-5, z_easement])
    line(convert_a_ft2mm([0, 0, 0]), convert_a_ft2mm([181.67, 0, 0]), local_line_size);

    color( "LightSlateGray" )
    translateInFt([181.67/2, 103.24-6, z_easement])
    text("<-- 5 ft Setback -->", font_size*0.8);

    //back yard
    color( "LightSlateGray" )
    translateInFt([10, 1, z_easement])
    line(convert_a_ft2mm([0, 0, 0]), convert_a_ft2mm([0, 102.24, 0]), local_line_size);

    color( "LightSlateGray" )
    translateInFt([9.5, 102.24/2 + 10, z_easement])
    rotate([0, 0, -90])
    text("<-- 10 ft Setback -->", font_size*0.8);

    //south side yard
    color( "LightSlateGray" )
    translateInFt([1, 5, z_easement])
    rotate([0, 0, 5])
    line(convert_a_ft2mm([0, 0, 0]), convert_a_ft2mm([175.87, 0, 0]), local_line_size);

    color( "LightSlateGray" )
    translateInFt([175.87/2, 12, z_easement])
    rotate([0, 0, 5])
    text("<-- 5 ft Setback -->", font_size*0.8);
    //front yard
}

module draw_storage(args) {
    //
    color("LightSlateGray", local_color_alpha)
    translateInFt([106, 103.24-6, 0])
    square(size=[convert_in2mm(68), convert_in2mm(41)], center=true);
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