include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <../House/Carpet_corner.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
    diameter = 89; // 3.7 inches in mm
    thickness = 2; // 2 mm thickness for coaster
    brim_height = 2; // height of walls in lattice pattern
    brim_thickness = 2.5; // thickness of walls in lattice pattern
    bottom_thickness = LayerHeight * 4; // thickness of bottom layer of coaster

// draw_complete_coaster(diameter, thickness, brim_thickness, brim_height, bottom_thickness);
draw_coaster_brim_and_bottom(diameter, thickness, brim_thickness, brim_height, bottom_thickness);



// draw_coaster_insert(diameter, thickness);
// echo();
// echo(FileName = str("coaster_insert.stl"));
// echo();

module draw_coaster_brim_and_bottom(diameter, thickness, brim_thickness, brim_height, bottom_thickness) 
{
     echo();
     echo(FileName = str("coaster_brim_and_bottom.stl"));
     echo();

    // brim
    draw_coaster_brim(diameter, brim_thickness, brim_height);

    // bottom of coaster
    draw_coaster_bottom(diameter, bottom_thickness);

}

module draw_complete_coaster(diameter, thickness, brim_thickness, brim_height, bottom_thickness) 
{
     echo();
     echo(FileName = str("Coaster.stl"));
     echo();

    // insert
    draw_coaster_insert(diameter, thickness);

    // brim
    draw_coaster_brim(diameter, brim_thickness, brim_height);

    // bottom of coaster
    draw_coaster_bottom(diameter, bottom_thickness);

}

module draw_coaster_insert(diameter, insert_thickness) 
{
    linear_extrude(height=insert_thickness)    
    difference() 
    {        
        translate([diameter/2, diameter/2])
        circle(d=diameter);

        hex_lattice(sizeX = diameter, sizeY = diameter, hex_flat_d=5, gap=0.4, border=0);
    } 
}

module draw_coaster_brim(diameter, brim_thickness, brim_height) 
{
    linear_extrude(height=brim_height)
    difference() 
    {
        // Outer circle
        diaOuter = diameter + brim_thickness * 2;

        translate([diameter/2, diameter/2]) 
        circle(d=diaOuter, $fn=100);

        // Inner cutout circle
        translate([diameter/2, diameter/2])
        circle(d=diameter, $fn=100);
    }
    
    // chamfer on top edge of brim
    translate([diameter/2, diameter/2, brim_height])
    draw_chamfer([[0,0], [brim_thickness, 0], [brim_thickness, thickness]], diameter);

}

module draw_coaster_bottom(diameter, bottom_thickness) 
{
    translate([diameter/2, diameter/2, -bottom_thickness])
    linear_extrude(height=bottom_thickness)
    circle(d=diameter, $fn=100);

    // chamfer on bottom edge of brim
    translate([diameter/2, diameter/2, -bottom_thickness])
    draw_chamfer([[0,0], [brim_thickness, bottom_thickness], [0, bottom_thickness]], (diameter - brim_thickness/2));
}

module draw_chamfer(triangle, diameter) 
{
    echo(str("triangle", triangle));
    rotate_extrude($fn=200) 
        translate([diameter/2, 0, 0])
        polygon(points=triangle);
    
}