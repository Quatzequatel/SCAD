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
        archimedes_helix(height=240, base_width=210, top_width=20, twist=360*7, blade_thickness=4, segments=1200);
    }
    else
    {
        // Example usage: 3 turns of a spiral with a growth rate of 0.3
        archimedes_spiral_polygon(a=0, b=0.5, angle=360 *2, step=1);
    }
}

module archimedes_helix(height=100, base_width=50, top_width=20, twist=720, blade_thickness=5, segments=100) 
{
    difference()
    {
        union()
        {
            for (z = [0 : height/segments : height]) {
                scale_factor = 1 - (z / height) * (1 - top_width/base_width);
                
                translate([0, 0, z]) 
                    scale([scale_factor, scale_factor, 1]) 
                        rotate([0, 0, (twist/segments) * z]) 
                            linear_extrude(height=height/segments) {
                                offset(r=blade_thickness) 
                                    square([base_width, blade_thickness], center=true);
                            };
            }
            translate([0,0,height/2])
            cylinder(h= height, r = blade_thickness, center = true, $fn=100);
        }

        translate([0,0,height/2])
        cylinder(h= height+4, r = blade_thickness/2, center = true, $fn=100);
    }
    
}

// Returns an Archimedes spiral as a 2D polygon
module archimedes_spiral_polygon(a=0, b=1, angle=720, step=5) 
{
    pts = archimedes_spiral_points(a=a, b=b, angle=angle, step=step);
    // echo(pts = pts);
    polygon(pts);
}