/*
    use to build Casa projects

    Note:
        X = is horizontal which is also in the North-South vector.
        Y = is vertical in the East-West Vector.

    1. draw walls
    2. draw Casa
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

function M2mm(M) = M * 1000;

/*
    Dictiionarys
*/
Casa = 
[
    "Casa Infromation",
    ["first floor height", M2mm(3.04)],
];

// Floor_points = [
//     [0,0],
//     [M2mm(0), M2mm(10.67)],
//     [M2mm(7.16), M2mm(10.67)],
//     [M2mm(7.16), M2mm(7.49)],
//     [M2mm(6.10), M2mm(7.49)],
//     [M2mm(6.10), M2mm(4.12)],
//     [M2mm(7.93), M2mm(4.12)],
//     [M2mm(7.93), M2mm(1.22)],
//     [M2mm(10.66), M2mm(1.22)],
//     [M2mm(10.66), M2mm(-3.05)],
//     [M2mm(6.10), M2mm(-3.05)],
//     [M2mm(6.10), M2mm(0)],
//     [0,0]
// ];

Floor_points = [
    [0,M2mm(3.05)],
    [M2mm(0), M2mm(13.75)],
    [M2mm(8.45), M2mm(13.75)],
    [M2mm(8.45), M2mm(10.54)],
    [M2mm(7.39), M2mm(10.54)],
    [M2mm(7.39), M2mm(7.17)],
    [M2mm(9.22), M2mm(7.17)],
    [M2mm(9.22), M2mm(3.05)],
    [M2mm(11.95), M2mm(3.05)],
    [M2mm(11.95), M2mm(0)],
    [M2mm(6.10), M2mm(0)],
    [M2mm(6.10), M2mm(3.05)],
];


Wall_points = [
    [0,0],
    [0,convert_in2mm(1284)],
    [convert_in2mm(953),convert_in2mm(1284)],
    [convert_in2mm(953),0]
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
    Draw_Casa_Perrimeter();
}

module Draw_Casa_Perrimeter() 
{
    translate([M2mm(3), M2mm(5), 0]) 
    linear_extrude(height = gdv(Casa_Walls, "z")) 
    
    mirror([1,0,0])
    difference()
    {
        polygon(Floor_points);
        offset(delta= convert_in2mm(-8)) polygon(Floor_points);
    }
}


module Draw_Walls()
{
    linear_extrude(height = gdv(Casa_Walls, "z")) 
    difference()
    {
        offset(delta= convert_in2mm(8)) polygon(Wall_points);
        polygon(Wall_points);
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