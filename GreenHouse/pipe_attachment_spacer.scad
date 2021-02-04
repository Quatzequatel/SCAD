/*
    
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;


spacer_height = convert_in2mm(0.75);
spacer_width = convert_in2mm(2);
spacer_depth = convert_in2mm(0.75);

pipe_diameter = convert_in2mm(0.85);
pipe_length = convert_in2mm(4);
pipe_space_from_wood = convert_in2mm(0.5);

screw_diameter = GRK_cabinet_screw_shank_dia + 1;
screw_length = pipe_length;
screw_from_outer_wall = NozzleWidth * 6;

zip_tie_length = convert_in2mm(1);
zip_tie_width = ziptie_width + 2;
zip_tie_height = ziptie_thickness + 2;
zip_tie_from_outer_wall = NozzleWidth * 8;
zip_tie_angle = 40;

$fn = 100;


build();

module build(args) 
{
    make_pipe_achor(convert_in2mm(0));
}

module make_pipe_achor(additional_height)
{
    difference()
    {
        union()
        {
            linear_extrude(spacer_height + additional_height)
            square(size=[spacer_width, spacer_depth], center=true);        
        }      

        translate([0,0,pipe_space_from_wood + additional_height])
        make_pipe();

        translate([spacer_width/2 - screw_from_outer_wall, spacer_depth/2 - screw_from_outer_wall,0])
        make_screw_hole();

        translate([-spacer_width/2 + screw_from_outer_wall, spacer_depth/2 - screw_from_outer_wall,0])
        make_screw_hole();

        translate([ (spacer_width/2 - screw_from_outer_wall) , - (spacer_depth/2 - zip_tie_from_outer_wall ), 15 + additional_height])
        make_ziptie_hole(-zip_tie_angle);

        translate([ - (spacer_width/2 - screw_from_outer_wall)  , - (spacer_depth/2 - zip_tie_from_outer_wall ), 15 + additional_height])
        make_ziptie_hole(zip_tie_angle);
    }

}

module make_pipe()
{
    translate([0, pipe_length/2, pipe_diameter/2]) 
    rotate([90, 0, 0]) 
    {
        linear_extrude(pipe_length)
            circle(d=pipe_diameter);
    }
}

module make_screw_hole()
{
    translate([0, 0, -screw_length/2]) 
        linear_extrude(screw_length)
            circle(d=screw_diameter);
}

module make_ziptie_hole(angle)
{
    rotate([0, angle, 0])
    translate([-zip_tie_height/2, -zip_tie_width/2, -zip_tie_length/2]) 
        linear_extrude(zip_tie_length)
            square([zip_tie_height, zip_tie_width]) ;
}