include <constants.scad>;
include <../FrenchWall/ToolHolders_Library.scad>;
use <../House/Carpet_corner.scad>;
use <../FrenchWall/ToolHolders_Modules_Library.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;
    diameter = 89; // 3.7 inches in mm
    insert_thickness = 2; // 2 mm thickness for coaster insert
    brim_height = 2.5; // height of walls in lattice pattern
    brim_thickness = 2.5; // thickness of walls in lattice pattern
    bottom_thickness = LayerHeight * 12; // thickness of bottom layer of coaster

// draw_complete_coaster(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness);
// draw_coaster_brim_and_bottom(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness);
draw_coasters_holder(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness);



// draw_coaster_insert(diameter, insert_thickness);
// echo();
// echo(FileName = str("coaster_insert.stl"));
// echo();

module draw_coasters_holder(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness, cosaster_count = 12) 
{
     echo();
     echo(FileName = str("Coasters Holder.stl"));
     echo();
    // body...
    holder_wall_thickness = 6;
    space_between_coasters_and_holder = 2; // space between coasters in holder for easy removal
    holder_height = bottom_thickness + (brim_height * cosaster_count) + 2; // height of holder walls, add extra 2 mm for clearance when inserting coasters
    // Outer circle
    diaOuter = diameter + (brim_thickness * 2) + holder_wall_thickness; // add holder wall thickness to diameter for spacing between coasters
    diaInner = diameter + (brim_thickness * 2) + space_between_coasters_and_holder; // add holder wall thickness to diameter for spacing between coasters

    echo(str("holder_height = ", holder_height));
    echo(str("diaOuter = ", diaOuter)); 
    echo(str("diaInner = ", diaInner));
    echo(str("diameter = ", diameter));

    translate([-3, -2.5, 0]) 
    difference()
    {
        union()
        {
            color("SaddleBrown")
            linear_extrude(height=holder_height)
            difference() 
            {

                translate([diaOuter/2, diaOuter/2]) 
                circle(d=diaOuter, $fn=100);

                // Inner cutout circle
                translate([diaOuter/2, diaOuter/2])
                circle(d=diaInner, $fn=100);
            }        

            translate([ 2.75, 3.4, 0]) // translate down slightly to ensure cut goes all the way through
            draw_coaster_brim_and_bottom(diaInner-2, insert_thickness, brim_thickness, brim_height, bottom_thickness);     
        }
       
        // cutouts for coasters
        translate([0, diaInner/2, bottom_thickness]) // translate down slightly to ensure cut goes all the way through
        draw_finger_slot(holder_height, finger_diameter=15, thickness=10);

        translate([diaOuter , diaInner/2, bottom_thickness]) // translate down slightly to ensure cut goes all the way through
        draw_finger_slot(holder_height, finger_diameter=15, thickness=10);
    }

}

module draw_finger_slot(holder_height, finger_diameter, thickness = 10) 
{
     echo();
    //  echo(FileName = str("Finger Slot.stl"));
     echo();

    translate([thickness/2, 0, 0])
    rotate([0, -90, 0])
    linear_extrude(height=thickness)
    hull() 
    {
        translate([finger_diameter/2, 0, 0])
        circle(d=finger_diameter, $fn=100);
        translate([(2 * holder_height) - (finger_diameter * 2), 0, 0])
        circle(d=finger_diameter, $fn=100);        
    }

}

module draw_coaster_brim_and_bottom(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness) 
{
     echo();
     echo(FileName = str("coaster_brim_and_bottom.stl"));
     echo();

    // brim
    draw_coaster_brim(diameter, brim_thickness, brim_height);

    // bottom of coaster
    draw_coaster_bottom(diameter, bottom_thickness);

}

module draw_complete_coaster(diameter, insert_thickness, brim_thickness, brim_height, bottom_thickness) 
{
     echo();
     echo(FileName = str("Coaster.stl"));
     echo();

    // insert
    draw_coaster_insert(diameter, insert_thickness);

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
    draw_chamfer([[0,0], [brim_thickness, 0], [brim_thickness, insert_thickness]], diameter);

}

module draw_coaster_bottom(diameter, bottom_thickness) 
{
    translate([diameter/2, diameter/2, -bottom_thickness])
    linear_extrude(height=bottom_thickness)
    circle(d=diameter, $fn=100);

    // chamfer on bottom edge of brim
    translate([diameter/2, diameter/2, -bottom_thickness - 0.0])
    draw_chamfer([[0,0], [brim_thickness, bottom_thickness ], [0, bottom_thickness ]], (diameter - brim_thickness/2) + 0.7);
}

module draw_chamfer(triangle, diameter) 
{
    echo(str("triangle = ", triangle));
    echo(str("diameter = ", diameter));
    rotate_extrude($fn=200) 
        translate([diameter/2, 0, 0])
        polygon(points=triangle);
    
}