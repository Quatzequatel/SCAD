/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

    
build(cap_gap_spacer);    

module build(properties) 
{
    cap_gap_spacer_v2(properties);
}

module cap_gap_spacer_v2(properties)
{
    difference()
    {
        linear_extrude(gdv(properties, "spacer_height"))
        union()
        {
            //walls
            cap_gap_wall(properties);
            
            translate([0,gdv(properties, "spacer_width") + gdv(properties, "plate_thickness"),0])
            cap_gap_wall(properties);
            //spacer
            translate([0, gdv(properties, "spacer_width")/2, 0])
            difference()
            {
                square(size=[gdv(properties, "spacer_width"), gdv(properties, "spacer_width")], center=true); 

                square(
                    size=[
                        gdv(properties, "spacer_width") - gdv(properties, "spacer_wall_thickness"), 
                        gdv(properties, "spacer_width") - gdv(properties, "spacer_wall_thickness2")
                    ], 
                    center=true
                );          
            }        
        }    

        plate_screwhole_v2(properties);    
    }



}

module cap_gap_wall(properties)
{
    translate([0,-gdv(properties, "plate_thickness")/2,0])    
    square(size=[gdv(properties, "plate_width"), gdv(properties, "plate_thickness")], center=true);  
}

module cap_gap_spacer_v1(properties)
{
    cap_gap_plate(properties);
    cap_gap_spacer(properties);

    translate([0, 0, gdv(properties, "spacer_height") + gdv(properties, "plate_thickness")]) 
    cap_gap_plate(properties);    
}

module cap_gap_plate(properties)
{
    translate([0,0, -gdv(properties, "plate_thickness")])
    difference()
    {
        linear_extrude(gdv(properties, "plate_thickness"))
        square(size=[gdv(properties, "plate_width"), gdv(properties, "plate_length")], center=true);   

        
    }
}

module cap_gap_spacer(properties)
{
    translate([0, gdv(properties, "spacer_width")/2, gdv(properties, "spacer_width")/2])
    rotate(gdv(properties, "spacer_rotation"))
    difference()
    {
        linear_extrude(gdv(properties, "spacer_height"))
        square(size=[gdv(properties, "spacer_width"), gdv(properties, "spacer_width")], center=true);  

        translate([0,0,-2])
        linear_extrude(gdv(properties, "spacer_height") + 5)
        square(
            size=[
                gdv(properties, "spacer_width") - gdv(properties, "spacer_wall_thickness"), 
                gdv(properties, "spacer_width") - gdv(properties, "spacer_wall_thickness2")
            ], 
            center=true
        );  
    }
}

module plate_screwhole(properties)
{
    locations = [
        [
            -1 * gdv(properties, "plate_width")/2 + convert_in2mm(in = 0.5),
            convert_in2mm(in = 0.5),
            0
        ],
        [
            gdv(properties, "plate_width")/2 - convert_in2mm(in = 0.5),
            convert_in2mm(in = 0.5),
            0
        ],
        [
            gdv(properties, "plate_width")/2 - convert_in2mm(in = 0.5),
            convert_in2mm(in = 0.5) * -1,
            0
        ],
        [
            -1 * gdv(properties, "plate_width")/2 + convert_in2mm(in = 0.5),
            convert_in2mm(in = 0.5) * -1,
            0
        ]
    ];
    for (i=[0:3]) 
    {
        translate( locations[i])
        cylinder(d=gdv(properties, "plate_screw_diameter"), h=10, center=true, $fn=100); 
    }
}

module plate_screwhole_v2(properties)
{
    locations = [
        [
            -1 * gdv(properties, "plate_width")/2 + convert_in2mm(in = 0.5),
            convert_in2mm(in = 0.5) + gdv(properties, "spacer_height")/2,
            0
        ],
        [
            gdv(properties, "plate_width")/2 - convert_in2mm(in = 0.5),
            convert_in2mm(in = 0.5) + gdv(properties, "spacer_height")/2,
            0
        ],
        [
            gdv(properties, "plate_width")/2 - convert_in2mm(in = 0.5),
            convert_in2mm(in = 0.5) * -1 + gdv(properties, "spacer_height")/2,
            0
        ],
        [
            -1 * gdv(properties, "plate_width")/2 + convert_in2mm(in = 0.5),
            convert_in2mm(in = 0.5) * -1 + gdv(properties, "spacer_height")/2,
            0
        ]
    ];
    for (i=[0:3]) 
    {
        rotate([90,0,0])
        translate( locations[i])
        cylinder(d=gdv(properties, "plate_screw_diameter"), h=gdv(properties, "plate_width"), center=true, $fn=100); 
    }
}

cap_gap_spacer = 
[
    "cap_gap_spacer",
        ["spacer_width", 40],
        // ["spacer_thickness", LayersToHeight(10)],
        ["spacer_wall_thickness", WallThickness(8)] ,
        ["spacer_wall_thickness2", LayersToHeight(13)] ,
        ["spacer_height", convert_in2mm(1.5)] ,
        ["spacer_rotation", [90,0,0]] ,
        ["plate_width", 90] ,
        ["plate_length", 40] ,
        ["plate_thickness", WallThickness(4)],
        ["plate_screw_diameter", woodScrewShankDiaN_8],
        //11.25 * 12 = 135 / 2 =>  67.5 + board2x6.x / 2 => 68.25
        ["pre-translate", [0, -convert_in2mm(in = 68.25),0] ],        
        ["location", [0, -convert_in2mm(in = 31.39), convert_in2mm(in = 27.8)]],
        ["color", "green"],
        ["brace color", "yellow"]
];