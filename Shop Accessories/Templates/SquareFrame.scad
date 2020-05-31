$fn=100;
include <constants.scad>;
use <morphology.scad>;
use <convert.scad>;
use <vectorHelpers.scad>;

Board2x4 = 
[
    convert_in2mm(in = 1.8),
    convert_in2mm(in = 3.55), 
    convert_in2mm(in = 8)
];

shellThickness = 6;
shellCut = shellThickness + 4;
screw_guide = [woodscrewHeadRad + 1, Board2x4.y - Board2x4.x/2, shellCut];

build();

module build(args) 
{
    // T_frame();
    Corner_frame();
}

module T_frame()
{
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

module Corner_frame()
{
    difference()
    {
        union()
        {
            linear_extrude(Board2x4.y)
            shell(d=shellThickness) 
            union()
            {
                square(size=[Board2x4.x, Board2x4.y ], center=false);
                translate([Board2x4.x,0,0])
                rotate([0,0,90])
                square(size=[Board2x4.x, Board2x4.y ], center=false);        
            }

            linear_extrude(shellThickness)
            // shell(d=shellThickness) 
            union()
            {
                square(size=[Board2x4.x, Board2x4.y ], center=false);
                translate([Board2x4.x,0,0])
                rotate([0,0,90])
                square(size=[Board2x4.x, Board2x4.y ], center=false);        
            }            
        }

        union()
        {
            //cut through
            translate([0,0, shellThickness])            
            linear_extrude(Board2x4.y + shellCut)
            union()
            {
                square(size=[Board2x4.x, Board2x4.y + shellCut ], center=false);
                translate([Board2x4.x,0,0])
                rotate([0,0,90])
                square(size=[Board2x4.x, Board2x4.y + shellCut ], center=false);        
            }   

            screw_guide_rotation_1 = [-90, 0, 0];
            screw_guide_translate_1 = [Board2x4.x/2, -shellCut, 0];
            //screw guildes
            for( i = [1:1:3]) 
            {
                translate(vAddToAxis(v = screw_guide_translate_1, axis = 2, value = (i * 0.25 * Board2x4.y)))
                rotate(screw_guide_rotation_1)
                cylinder(d = screw_guide.x, h=Board2x4.y, center=false);  
            }

            //screw guildes
            screw_guide_rotation_2 = [0, -90, 0];
            screw_guide_translate_2 = [Board2x4.x + shellCut, Board2x4.x/2, screw_guide.x];

            for( i = [1:1:3]) 
            {
                translate(vAddToAxis(v = screw_guide_translate_2, axis = 2, value = (i * 0.25 * Board2x4.y)))
                rotate(screw_guide_rotation_2)
                cylinder(d = screw_guide.x, h=Board2x4.y, center=false);  
            }
        }
    }

}