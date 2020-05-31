// $fn=100;
include <constants.scad>;
use <morphology.scad>;
use <convert.scad>;

Board2x4 = 
[
    convert_in2mm(in = 1.8),
    convert_in2mm(in = 3.55), 
    convert_in2mm(in = 8)
];

build();

module build(args) 
{
    T_frame();
}

module T_frame()
{
    shellThickness = 6;
    shellCut = shellThickness + 4;
    screw_guide = [woodScrewShankDiaN_10, Board2x4.y - Board2x4.x/2, shellCut];

    difference()
    {
        union()
        {
            //main line
            translate([0, 0, Board2x4.y/2]) 
            rotate([90,0,90])
            linear_extrude(height = Board2x4.z)
            shell(d=shellThickness) square(size=[Board2x4.x, Board2x4.y], center=true);

            translate([Board2x4.z/2, -Board2x4.x/2, Board2x4.y/2]) 
            rotate([90,0,0])
            linear_extrude(height = Board2x4.z/2)
            shell(d=shellThickness) square(size=[Board2x4.x, Board2x4.y], center=true);
        }

        union()
        {
            //cut through
            translate([Board2x4.z/2, -Board2x4.x/2+shellCut, Board2x4.y/2]) 
            rotate([90,0,0])
            linear_extrude(height = Board2x4.z/4)
            square(size=[Board2x4.x, Board2x4.y], center=true);         

            //remove top
            translate([0, 0, Board2x4.y/2 + shellCut]) 
            rotate([90,0,90])
            linear_extrude(height = Board2x4.z)
            square(size=[Board2x4.x, Board2x4.y], center=true);

            translate([Board2x4.z/2, -Board2x4.x/2, Board2x4.y/2 + shellCut]) 
            rotate([90,0,0])
            linear_extrude(height = Board2x4.z/2)
            square(size=[Board2x4.x, Board2x4.y], center=true);         

            //screw guilde
            translate([Board2x4.z/2, Board2x4.x/2 + shellCut/2 -2, 0])
            translate([-screw_guide.x/2,-screw_guide.z/2, 0.75 * Board2x4.y + 2*screw_guide.x])
            rotate([0,90,90])
            linear_extrude(shellCut)
            hull()
            {
                circle(d=screw_guide.x);
                translate([screw_guide.y,0,0])
                circle(d=screw_guide.x);   
            }
               
        }
    }

}

