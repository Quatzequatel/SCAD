$fn=100;
include <constants.scad>;
use <morphology.scad>;
use <convert.scad>;
use <vectorHelpers.scad>;

Board2x4 = 
[
    convert_in2mm(in = 1.5),
    convert_in2mm(in = 3.55), 
    convert_in2mm(in = 3.55 + 1.5)
];

floorThickness = LayersToHeight(14);
shellThickness = 5.55;
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
            linear_extrude(Board2x4.y)
            shell(d=shellThickness) 
            union()
            {
                translate([ 0, (-Board2x4.z + Board2x4.x)/2, 0])
                square(size=[Board2x4.x, Board2x4.z ], center=false);
                translate([Board2x4.x,0,0])
                rotate([0,0,90])
                square(size=[Board2x4.x, Board2x4.y ], center=false);        
            }

            //floor
            linear_extrude(floorThickness)
            union()
            {
                translate([ 0, (-Board2x4.z + Board2x4.x)/2, 0])
                square(size=[Board2x4.x, Board2x4.z ], center=false);
                translate([Board2x4.x,0,0])
                rotate([0,0,90])
                square(size=[Board2x4.x, Board2x4.y ], center=false);      
            }            
        }

        union()
        {
            //cut through
            translate([0, 0, floorThickness]) 
            linear_extrude(height = Board2x4.z)
            union()
            {
                translate([ 0, (-(Board2x4.z + 2*shellCut) + Board2x4.x)/2, 0])
                square(size=[Board2x4.x, Board2x4.z + 2*shellCut], center=false);
                translate([Board2x4.x,0,0])
                rotate([0,0,90])
                square(size=[Board2x4.x, Board2x4.y + shellCut], center=false);      
            }  

            //screw guildes
            screw_guide_rotation = [0, -90, 0];
            screw_guide_translate = [Board2x4.x + shellCut, Board2x4.x/2, 0];

            for( i = [1:1:3]) 
            {
                translate(vAddToAxis(v = screw_guide_translate, axis = 2, value = (i * 0.25 * Board2x4.y)))
                rotate(screw_guide_rotation)
                cylinder(d = screw_guide.x, h=Board2x4.y, center=false);  
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

            linear_extrude(floorThickness)
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
            translate([0,0, floorThickness])            
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