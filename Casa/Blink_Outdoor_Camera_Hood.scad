use <convert.scad>;

/*
    Notes: 
    Currently buildls a nice cover for a blink 4th gen camera.
    The camera fits loosely into case. Did not want to make it snug, 
    for better heat to disapation.
*/

$fn=200;
build();



module build(args) 
{
    case_height = 35;
    case_width = 47;
    shade_extension = 20;
    difference()
    {
        union()
        {
            draw_case(case_height, case_width, 1);
            translate([14,0,0])
            draw_Shade(rad = convert_in2mm(2.5), height = case_height + shade_extension, res = 200);
        }

        translate([-16/2, - (case_width - 15), 19])
        draw_Speaker_hole(16, 5, case_width);

    }
}

module draw_case(height = 32.0, width = 47, thickness = 1 ) 
{
    rotate([0,0,180])
    union()
    {

        draw_pilar(height);

        rCorner_1 = 13.5;
        rCorner_2 = rCorner_1 + thickness;
        width2 = width - 3.2;

        z1 = 0.1;
        z2 = 0.2;

        //hole size
        hole_radius = 30;

        difference()
        {
            //main
            minkowski()
            {
                cube([width, width, z1], true);
                cylinder(r=rCorner_2, h=height);
            };

            //cut
            minkowski()
            {
                cube([width2, width2, z2], true);
                cylinder(r=rCorner_1, h=height);
            }
        }

        //bottom of case
        difference()
        {
            minkowski()
            {
                cube([width,width, z1], true);
                cylinder(r=14.5, h=0.5);
            };

            translate([0,0,-3])
            cylinder(r=hole_radius, h=height);
        } 
    }   
}

module draw_pilar(case_height)
{
    pilar_width = 14;
    pilar_height = 10;
    y_move = case_height ;
    
    x_move = 38;
    z_move = 7;

    translate([x_move, 0, z_move])
    rotate([90,0,90])
    linear_extrude(height = pilar_height)
    hull() 
        {
            translate([0, y_move, 0]) circle(d = pilar_width);
            circle(d = pilar_width);
        }
}

//
// Creates a cresent moon cap to shade the camera.
//
module draw_Shade(rad, height, res)
{
    // rad = radius = in millimeters (OpenSCAD uses mm)
    // cap, is a cresent moon shape created from the intersection of 2 circles.
    // the 2nd circle is a little larger to create the cresent
    
    rad2 = rad + 5; // increasing value makes short thinner cresent.
                    // decreasing value makes longer thicker cresent.
    // resolution = 200; // Number of segments in the arc
    max_thickness = 10; //max thickness of shade cover.

    linear_extrude(height=height)
    difference() 
    {
        circle(rad, $fn=res);
        translate([max_thickness, 0, 0])
        circle(rad2, $fn=res);
    }
}

//
// draw a cut out for the speaker on the left side of the camera.
//
module draw_Speaker_hole(whole_length, whole_width, case_width)
{
    zheight = 10;
    
    rotate([90, 0, 0])     
    linear_extrude(height = zheight)
    hull()
    {
        circle(d = whole_width);
        translate([whole_length, 0, 0]) circle(d = whole_width);
    }
}


