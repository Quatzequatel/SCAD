/*
    This is the main file for drawing the whole casa. 

    use to build Casa projects

    What is next;
        break project into multiple files. think of layers or focus area.
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
include <Casa_globals.scad>;
use <Draw_Casa.scad>;
use <Draw_Wall.scad>;
use <Draw_Carport.scad>;
use <Draw_Pool.scad>;
use <Draw_Lables.scad>;
use <Draw_Irrigation.scad>;
use <Draw_Bodaga.scad>;
use <Draw_Planter.scad>;


use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;



/*
    Dictiionarys
*/
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

build();

module build(args) 
{
    // scale_large();
    // Draw_landmarks();
    Draw_Casa();
    Draw_Carport();
    Draw_Walls();
    Draw_Pool();
    Draw_Lables();
    Draw_Bodaga();
    Draw_Irrigation();
    Draw_Planter();
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