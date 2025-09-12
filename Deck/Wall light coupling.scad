/*
This is the wall light coupling that goes on the deck side of the wall light.
It provides a spacer to account for the gap between the wall and the deck boards.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

light_coupling_dict = 
    ["name",
            ["mounting strap lengh", 98.2],
            ["mounting strap width", 20],
            ["adj screw length", 28.5],
            ["adj screw width", 4.21],
            ["adj screw x offset", (98.2/2 - 28.5)/2 + 6],
    ];
screwTube_h = 6.1;
screwTube_d = gdv(light_coupling_dict, "adj screw width") + 2;

build();

module build()
{
    // draw_mounting_strap();
    draw_cover_bracket();
}

module draw_mounting_strap()
{
    color("LightGray", 0.5)
    difference()
    {
        union()
        {
            linear_extrude(height = 2,  slices = 20)
            difference()
            {
                minkowski()
                {
                    square([gdv(light_coupling_dict, "mounting strap lengh"), gdv(light_coupling_dict, "mounting strap width")], center = true);
                    circle(d=gdv(light_coupling_dict, "adj screw width"), $fn=20);
                }
                
                translate([gdv(light_coupling_dict, "adj screw x offset"), 0,0])
                hull()
                {
                    translate([28.5,0,0])
                    circle(d=gdv(light_coupling_dict, "adj screw width"), $fn=20);
                    circle(d=gdv(light_coupling_dict, "adj screw width"), $fn=20);
                }

                translate([-gdv(light_coupling_dict, "adj screw x offset"), 0,0])
                hull()
                {
                    translate([-28.5,0,0])
                    circle(d=gdv(light_coupling_dict, "adj screw width"), $fn=20);
                    circle(d=gdv(light_coupling_dict, "adj screw width"), $fn=20);
                }

                circle(d=gdv(light_coupling_dict, "adj screw width"), $fn=20);
            }
        }
        
        translate([0,0,-1])
        cylinder(d=screwTube_d + 0.25, h = screwTube_h + 3, $fn=20);
    }
}

module draw_cover_bracket()
{
    length = 46;
    width = 20;
    height = 3;
    offset = 30;
    tri_start = 22;
    tri_w = 6;
    tri_h = 36;
    shp_w = 4;
    shp_h = 6;
    

    difference()
    {
        // color("LightBlue", 0.5)
        union()
        {
            color("LightGreen", 0.5)
            linear_extrude(height = height,  slices = 20)
            translate([0, offset,0])
            // rotate([0,0,180])
            minkowski()
            {        
                // translate([0,-width+2.6,0])
                // square([length/2, width], center = true);
                color("LightGreen", 0.5)
                polygon(points=[
                    [shp_w * -2, 0],
                    [shp_w * -1, shp_h],
                    [shp_w * 1, shp_h],
                    [shp_w * 2, 0],
                    [shp_w * 0, -tri_w]
                    ]);
                circle(d=2, $fn=20);
            }

            color("LightGreen", 0.5)
            linear_extrude(height = height, slices = 20)

            translate([0,-offset,0])
            rotate([0,0,180])    
            minkowski()
            {
                
                polygon(points=[
                    [shp_w * -2, 0],
                    [shp_w * -1, shp_h],
                    [shp_w * 1, shp_h],
                    [shp_w * 2, 0],
                    [shp_w * 0, -tri_w]
                    ]);
                circle(d=2, $fn=20);
            }

            translate([0,0,height])
            linear_extrude(height = height, slices = 20)
            // translate([0, -offset, 0])
            minkowski()
            {
                rotate([0,0,90])
                square([length + offset - 3, width], center = true);
                circle(d=2, $fn=20);
            }

            cylinder(d=screwTube_d, h = screwTube_h, $fn=20);

        }       

        union()
        {
            translate([0,0,-1])
            cylinder(d=gdv(light_coupling_dict, "adj screw width"), h = screwTube_h + 3, $fn=20);

            translate([0,31.47,-1])
            cylinder(d=gdv(light_coupling_dict, "adj screw width"), h = screwTube_h + 3, $fn=20);
            translate([0,-31.47,-1])
            cylinder(d=gdv(light_coupling_dict, "adj screw width"), h = screwTube_h +3, $fn=20);
        }
    }

}