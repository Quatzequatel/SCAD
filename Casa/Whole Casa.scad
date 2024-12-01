/*
    use to build Casa projects

    What is next;
        add existing walkway around house.
        add desired walkway from front to back of house.
        add plants into drawing.
        add toolshed
        add raised bed.
        add palm trees
        add fruit trees.

    Note:
        X = is horizontal which is also in the North-South vector.
        Y = is vertical in the East-West Vector.

    1. draw walls
    2. draw Casa
    3. draw landmarks - these are measurement verification lines
    4. draw carport
    5. draw pool - ball park to refine.
    6. draw labels - catch all for labeling.
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



Floor_points = [
    [M2mm(6.10), M2mm(0)],     //0
    [M2mm(11.95), M2mm(0)],     //1
    [M2mm(11.95), M2mm(4.27)],     //2
    [M2mm(9.22), M2mm(4.27)],     //3
    [M2mm(9.22), M2mm(7.17)],     //4
    [M2mm(7.39), M2mm(7.17)],     //5
    [M2mm(7.39), M2mm(10.54)],     //6
    [M2mm(8.45), M2mm(10.54)],     //7
    [M2mm(8.45), M2mm(13.72)],     //8
    [M2mm(0), M2mm(13.72)],     //9
    [M2mm(0), M2mm(3.05)],     //10
    [M2mm(6.10), M2mm(3.05)],     //11
    [M2mm(6.10), M2mm(0)],     //12
];

Floor_Center = [-M2mm(11.95)/2, -M2mm(13.72)/2];


Wall_points = [
    [0,0],
    [0,convert_in2mm(1284)],
    [convert_in2mm(953),convert_in2mm(1284)],
    [convert_in2mm(953),0]
];

Carport_points = [
    [0,0],
    [0, convert_in2mm(298)],
    [convert_in2mm(171), convert_in2mm(298)],
    [convert_in2mm(171), 0],
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

Casa_pool = 
[
    "pool demensions, in meters",
    ["x", 5.0],
    ["y", 10.0],
    ["z", 0],
];

build();

module build(args) 
{
    scale_large();
    Draw_landmarks();
    Draw_Casa();
    Draw_Carport();
    Draw_Walls();
    Draw_Pool();
    Draw_Lables();
}


module Draw_Pool() 
{
    
    translate([M2mm(M = 2.5), M2mm(M = 8), 0])
    color("SteelBlue", 1.0)
    square(size = [M2mm(M = gdv(Casa_pool, "x")), M2mm(gdv(Casa_pool, "y"))]); 
}
module Draw_landmarks() 
{
    //north wall to house
    color( "red", 0.5) 
    translate([convert_in2mm(953 - 140.5),convert_in2mm(1284/2),0]) 
    square(size = [convert_in2mm(140.5), convert_in2mm(6)]);

    //Eech direction around the house needs landmarks.

    //East wall to house
    color( "yellow", 0.5) 
    translate([convert_in2mm(953/2),convert_in2mm(950),0]) 
    rotate([0, 0, 90])
    square(size = [convert_in2mm(341), convert_in2mm(6)]);

    //west wall to house
    color( "blue", 0.5) 
    translate([convert_in2mm(953/2 +60),convert_in2mm(12),0]) 
    rotate([0, 0, 90])
    square(size = [convert_in2mm(341), convert_in2mm(6)]);

    //south wall to house
    color( "red", 0.5) 
    translate([convert_in2mm(0),convert_in2mm(1284/1.5),0]) 
    rotate([0, 0, 0])
    square(size = [convert_in2mm(331), convert_in2mm(6)]);
}

module Draw_Casa()
{
    Draw_Casa_Perrimeter();
}

module Draw_Carport() 
{
    //this is the carport
    translate([convert_in2mm(61), M2mm(32.75) - convert_in2mm(298),0]) 
    linear_extrude(height = convert_in2mm(8)) 
    polygon(Carport_points);

    //driveway needs to verified and corrected.
    translate([M2mm(16), M2mm(26.75) - convert_in2mm(240),0]) 
    linear_extrude(height = convert_in2mm(8)) 
    square(size = [convert_in2mm(120), convert_in2mm(341) + M2mm(3.50)]);
}

module Draw_Casa_Perrimeter() 
{
    translate([M2mm(14.5), M2mm(17), 0]) 
    linear_extrude(height = gdv(Casa, "first floor height")) 

    // mirror([1,0,0])
    rotate([0, 0, 180]) 
    translate(Floor_Center) 
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
    text(gdv(Casa_Lables,"east"), font_lable_size);

    color(font_lable_color, 1.0)
    translate(v = [convert_in2mm(953)/2, convert_in2mm(1284 + 36), 0]) 
    text(gdv(Casa_Lables,"west"), font_lable_size);

    color(font_lable_color, 1.0)
    translate(v = [-convert_in2mm(24), convert_in2mm(1284)/2, 0]) 
    rotate([0, 0, 90])     
    text(gdv(Casa_Lables,"south"), font_lable_size);

    color(font_lable_color, 1.0)
    translate(v = [convert_in2mm(953) + convert_in2mm(48), convert_in2mm(1284)/2, 0])  
    rotate([0, 0, 90])     
    text(gdv(Casa_Lables,"north"), font_lable_size);
}

//puts a foot scale on X and Y axis for point of reference.
module scale_large(size = 30, increment = M2mm(1), fontsize = 200)
{
  if($preview)
  {
    for (i=[0:size]) 
    {
        translate([f(i, increment), -increment/2, 0])
        color("blue", 0.5)
        union()
        {
            rotate([0,0, -90]) 
            text(text = str(i * 10, " M"), size = fontsize);
            rotate([90,0])
            cylinder(r=convert_in2mm(1), h=f(1, increment/2), center=true);
        }

        translate([-increment/2, f(i, increment), 0])
        color("blue", 0.5)
        union()
        {
            text(text = str(i * 10, " M"), size = fontsize);
            rotate([0,90])
            cylinder(r=convert_in2mm(1), h=f(1, increment/2), center=true);
        }   
    }     
  }
}