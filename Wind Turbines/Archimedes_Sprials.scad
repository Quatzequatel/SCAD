/*
   This project is to design the yard of Casa Bumblebee and the pool area.
   1. Check-in of basic templates.
*/
// include <constants.scad>;

// use <convert.scad>;
// use <trigHelpers.scad>;
// use <ObjectHelpers.scad>;
// use <dictionary.scad>;


function archimedes_spiral_points(a=0, b=1, angle=720, step=1) =
    [
        for (theta = [0 : step : angle])
            let (r = a + b * theta)
            [r * cos(theta), r * sin(theta)]
    ];

build("helix");

module build(args)
{
    if(args == "helix")
    {
        // Example usage with tapering effect        
        archimedes_helix(height=400, base_width=400, top_width=20, twist=360*2, blade_thickness=10, segments=1000, blade_count = 4);
    }
    else
    {
        // Example usage: 3 turns of a spiral with a growth rate of 0.3
        archimedes_spiral_polygon(a=0, b=0.5, angle=360 *2, step=1);
    }
}

/* 
    Details:
        height=100, - Height of model.
        base_width=50, - diameter of model base, blade base lenth = base_width/2
        top_width=20,  - diameter of model top.
        twist=720,     - number of degrees to rotate model.
        blade_thickness=5, - thickness of blade
        segments=100,  - number of slices in model, res = height/segments
        blade_count = 1,   - number of blades
        $fn = 20
*/
module archimedes_helix(height=100, base_width=50, top_width=20, twist=720, blade_thickness=5, segments=100, blade_count = 1, $fn = 60) 
{
    half_base_width = base_width/2;
    difference()
    {
        union()
        {
            for (z = [0 : height/segments : height]) {
                scale_factor = 1 - (z / height) * (1 - top_width/base_width);
                
                translate([0, 0, z]) 
                    scale([scale_factor, scale_factor, 1]) 
                        rotate([0, 0, (twist/segments) * z]) 
                            linear_extrude(height=height/segments) 
                            {
                                if(blade_count < 2)
                                {
                                    offset(r=blade_thickness) 
                                        square([base_width, blade_thickness], center=true);
                                }
                                else
                                {
                                        for( degree = [0 : 360/blade_count : 360] )
                                        {
                                            rotate( [0,0,degree])
                                            translate([half_base_width/2, 0, 0])    
                                            //offset(r=blade_thickness) 
                                            square([half_base_width, blade_thickness], center=true);           
                                        }
                                }
                            };
            }

            //cylindar
            translate([0,0,height/2])
            cylinder(h= height, r = blade_thickness, center = true);
        }

        // Tube for axle
        translate([0,0,height/2])
        cylinder(h= height+4, r = blade_thickness/2, center = true);
    }
    
}

// Returns an Archimedes spiral as a 2D polygon
module archimedes_spiral_polygon(a=0, b=1, angle=720, step=5) 
{
    pts = archimedes_spiral_points(a=a, b=b, angle=angle, step=step);
    // echo(pts = pts);
    polygon(pts);
}

module blade_design(count = 3, base_radius = 50, blade_thickness = 20 )
{

}