/*
    use to build Casa projects
    1. draw walls
    2. draw Casa
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

/*
    Dictiionarys
*/
Casa = 
[
    "Casa Infromation",
    ["", convert_in2mm()],
];

Casa_gate = 
[
    "Gate information",
    ["gate1", convert_in2mm()],
    ["", convert_in2mm()],
];

Casa_bedroom = 
[
    "Casa bedroom information",
    ["height", convert_in2mm(25 * 12 + 5)],
    ["east", convert_in2mm(14 * 12 + 11.5)],
    ["north", convert_in2mm(14 * 12)],
];

Casa_Walls = 
[
    "Casa Wall information",
    ["x", convert_ft2mm(61)],
    ["y", convert_ft2mm(26)],
    ["z", convert_ft2mm(4)],
    ["wall width", convert_in2mm(8)],
    ["south wall", convert_in2mm(1284)],
    ["east wall", convert_in2mm(953)],
    ["north wall", convert_in2mm(1284)],
    ["west wall", convert_in2mm(953)],
    ["rotate",[0,0,0]],
    //["move",[convert_ft2mm(15), convert_ft2mm(25), convert_ft2mm(firstFlorLabels_ft)]],
    ["color", "Khaki"]
];

font_lable_size = 500;
font_lable_color = "black";

Casa_Lables =
[
    "Casa lables",
    ["south", "South Wall"],
    ["east", "East Wall"],
    ["north", "North Wall"],
    ["west", "West Wall"],
];

build();

module build(args) 
{
    Draw_Casa();
    Draw_Walls();
    Draw_Lables();
}

module Draw_Casa()
{
    Draw_Casa_Bedroom();
}

module Draw_Casa_Bedroom() 
{
    translate(
        v = 
        [
            convert_in2mm(391), 
            gdv(Casa_Walls, "south wall") - gdv(Casa_bedroom, "east") - convert_in2mm(395), 
            0
        ]) 
    linear_extrude(height = gdv(Casa_bedroom, "height"))
    difference() 
    {
        square(size = [
            gdv(Casa_bedroom, "east"), gdv(Casa_bedroom, "north")
        ]);

        translate(v = [gdv(Casa_Walls, "wall width"), gdv(Casa_Walls, "wall width"), 0]) 
        square(size = 
        [
            gdv(Casa_bedroom, "east") - 2 * gdv(Casa_Walls, "wall width"), 
            gdv(Casa_bedroom, "north") - 2 * gdv(Casa_Walls, "wall width")
        ]);
    }
}

module Draw_Walls()
{
    linear_extrude(height = gdv(Casa_Walls, "z")) 
    difference() 
    {
        square(size = [
            gdv(Casa_Walls, "east wall") + 2 * gdv(Casa_Walls, "wall width"), 
            gdv(Casa_Walls, "south wall") + 2 * gdv(Casa_Walls, "wall width")
            ]);
        translate(v = [gdv(Casa_Walls, "wall width"), gdv(Casa_Walls, "wall width"), 0]) 
        square(size = [gdv(Casa_Walls, "east wall"), gdv(Casa_Walls, "south wall")]);
    }
    
}

module Draw_Lables() 
{
    color(font_lable_color, 1.0)
    translate(v = [convert_in2mm(953)/2, -convert_in2mm(36), 0]) 
    text(gdv(Casa_Lables,"west"), font_lable_size);

    color(font_lable_color, 1.0)
    translate(v = [convert_in2mm(953)/2, convert_in2mm(1284 + 36), 0]) 
    text(gdv(Casa_Lables,"east"), font_lable_size);

    color(font_lable_color, 1.0)
    translate(v = [-convert_in2mm(24), convert_in2mm(1284)/2, 0]) 
    rotate([0, 0, 90])     
    text(gdv(Casa_Lables,"south"), font_lable_size);

    color(font_lable_color, 1.0)
    translate(v = [convert_in2mm(953) + convert_in2mm(48), convert_in2mm(1284)/2, 0])  
    rotate([0, 0, 90])     
    text(gdv(Casa_Lables,"north"), font_lable_size);
}