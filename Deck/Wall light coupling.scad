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
            ["mounting strap lengh", 88.2],
            ["mounting strap width", 20],
            ["adj screw length", 28.5],
            ["adj screw width", 4.21],
            ["adj screw x offset", (80/2 - 28.5)/2 + 6],
    ];
screwTube_h = 6.1;
screwTube_d = gdv(light_coupling_dict, "adj screw width") + 2;

build();

module build()
{
    draw_mounting_strap();
    // draw_cover_bracket();
    // baseplate();
}

module draw_mounting_strap()
{
    color("LightGray", 0.5)
    rotate([0,0,90])
    difference()
    {
        union()
        {
            linear_extrude(height = 6,  slices = 20)
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
    height = 6;
    offset = 30;
    tri_start = 22;
    tri_w = 6;
    tri_h = 36;
    shp_w = 4;
    shp_h = 6;
    nutDiameter = 17;
    

    difference()
    {
        // color("LightBlue", 0.5)
        union()
        {
            // color("Lightblue", 0.5)
            // linear_extrude(height = height,  slices = 20)
            // translate([0, offset,0])
            // // draw pentagon shape.
            // minkowski()
            // {        
            //     color("Lightblue", 0.5)
            //     polygon(points=[
            //         [shp_w * -2, 0],
            //         [shp_w * -1, shp_h],
            //         [shp_w * 1, shp_h],
            //         [shp_w * 2, 0],
            //         [shp_w * 0, -tri_w]
            //         ]);
            //     circle(d=2, $fn=20);
            // }

            // color("LightGreen", 0.5)
            // linear_extrude(height = height, slices = 20)
            // translate([0,-offset,0])
            // rotate([0,0,180])    
            // // draw pentagon shape.
            // minkowski()
            // {
                
            //     polygon(points=[
            //         [shp_w * -2, 0],
            //         [shp_w * -1, shp_h],
            //         [shp_w * 1, shp_h],
            //         [shp_w * 2, 0],
            //         [shp_w * 0, -tri_w]
            //         ]);
            //     circle(d=2, $fn=20);
            // }

            translate([0,0,height])
            linear_extrude(height = height, slices = 20)
            // draw rectangle shape.
            minkowski()
            {
                rotate([0,0,90])
                square([length + offset - 3, width], center = true);
                circle(d=2, $fn=20); //for rounded corners
            }

            cylinder(d=screwTube_d, h = screwTube_h, $fn=20);

        }       

        //cut holes for screws.
        union()
        {
            translate([0,0,-1])
            cylinder(d=gdv(light_coupling_dict, "adj screw width"), h = screwTube_h + 10, $fn=20);

            translate([0,31.47,-1])
            cylinder(d=gdv(light_coupling_dict, "adj screw width"), h = screwTube_h + 10, $fn=20);
            translate([0,-31.47,-1])
            cylinder(d=gdv(light_coupling_dict, "adj screw width"), h = screwTube_h +10, $fn=20);

            translate([11.7,0,7.5])
            cylinder(d=nutDiameter, h = 5, $fn=50);
        }
    }

}

module baseplate()
{
    length = 70;
    width = 20;
    height = 5;
    offset = 30;
    tri_start = 22;
    tri_w = width/2;
    tri_h = 15;
    shp_w = 4;
    shp_h = 6;
    nutDiameter = 17;

    // rotate([0,0,90])
    union()
    {
            color("purple", 0.5)
            linear_extrude(height = height,  slices = 20)
            translate([-4, 0,0])
            minkowski()
            {
                polygon(points=[
                    [0,tri_h],                
                    [-tri_w,0],
                    [0,-tri_h],
                    ]);
                circle(d=2, $fn=20);                
            }

    
    difference()
    {
        union()
        {
            color("pink", 0.5)
            linear_extrude(height = height,  slices = 20)
            rotate([0,0,90])
            translate([0,0,0])
            // draw rectangle shape.
            minkowski()
            {
                square([length, width], center = true);
                circle(d=2, $fn=20);
            }      


        }
 

        //cut holes for screws.
        union()
        {
            //external screw holes
            translate([0,31.47,-1])
            cylinder(d=gdv(light_coupling_dict, "adj screw width"), h = screwTube_h +3, $fn=20);
            translate([0,-31.47,-1])
            cylinder(d=gdv(light_coupling_dict, "adj screw width"), h = screwTube_h +3, $fn=20);

            //middle hole for mounting strap screw.
            translate([0,0,-1])
            cylinder(d=gdv(light_coupling_dict, "adj screw width"), h =10, $fn=20);
            
            //nut holes also remove some material for less plastic use.
            translate([width/2 -4,0,-1])
            cylinder(d=nutDiameter, h = 10, $fn=50);
            translate([width/2 + 2,0,-1])
            cube([nutDiameter, 3*nutDiameter, 15], center = true);

            translate([-width/2 - 3,0,-1])
            // cylinder(d=nutDiameter, h = 10, $fn=50);
            cube([nutDiameter, 3*nutDiameter, 15], center = true);

        }
    }
    }
}