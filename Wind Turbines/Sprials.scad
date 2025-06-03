/*
   This project is to design the yard of Casa Bumblebee and the pool area.
   1. Check-in of basic templates.
*/


//global parameters
function fibonacci(nth) = 
    nth == 0 || nth == 1 ? nth : (
        fibonacci(nth - 1) + fibonacci(nth - 2)
    );

build();

module build(args)
{
    // Example usage with tapering effect
    archimedes_helix(height=240, base_width=210, top_width=20, twist=360*7, blade_thickness=4, segments=1200);

    // Example: Adjust height, width, twist, and thickness
    // archimedes_helix_v1(height=120, width=60, twist=1080, blade_thickness=6, segments=300);    

    //golden spiral example.
    // golden_spiral(1, 8, 1); 
}

module archimedes_helix(height=100, base_width=50, top_width=20, twist=720, blade_thickness=5, segments=100) 
{
    for (z = [0 : height/segments : height]) 
    {
        scale_factor = 1 - (z / height) * (1 - top_width/base_width);
        
        translate([0, 0, z]) 
            scale([scale_factor, scale_factor, 1]) 
                rotate([0, 0, (twist/segments) * z]) 
                    linear_extrude(height=height/segments) {
                        offset(r=blade_thickness) 
                            #square([base_width, blade_thickness], center=true);
                    };
    }

    translate([0,0,height/2])
    difference()
    {
        cylinder(h= height, r = blade_thickness, center = true, $fn=100);
        cylinder(h= height+4, r = blade_thickness/2, center = true, $fn=100);
    }
    
}

module archimedes_helix_v1(height=100, width=50, twist=720, blade_thickness=5, segments=200) 
{
    linear_extrude(height=height, twist=twist, slices=segments) {
        offset(r=blade_thickness) 
            polygon([
                [width/2, 0], [-width/2, 0], [-width/2, blade_thickness], [width/2, blade_thickness]
            ]);
    }
}


///Golden Spiral modules
module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
} 

module golden_spiral(from, to, thickness) {
    if(from <= to) {
        f1 = fibonacci(from);
        f2 = fibonacci(from + 1);

        arc(f1, [0, 90], thickness, 48);

        offset = f2 - f1;

        translate([0, -offset, 0]) rotate(90)
            golden_spiral(from + 1, to, thickness);
    }
}

