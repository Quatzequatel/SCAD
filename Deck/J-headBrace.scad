/*
Description : the J-brace purpose; 
    a) to hold rubber in place.
    b) anchor for trough-spacer.
*/

/*****************************************************************************
CONSTANTS
*****************************************************************************/
$fn=100;
PI = 4 * atan2(1,1);

WALL_HEIGHT = 216;
FLOOR_WIDTH = 85;
TRUSS_HEIGHT = 80;
BRACE_WIDTH = 30;
BRACE_THICKNESS = 6;
TRIANGLE = [[0,0],[0,1],[1,0]];

/*****************************************************************************
FUNCTIONS - code to make reading modules easier to understand.
******************************************************************************/
function half(x) = x/2;

/*****************************************************************************
Directives - defines what to build with optional features.
*****************************************************************************/
INCLUDE_THING = 0;
BUILD_THING = 1;

/*****************************************************************************
MAIN SUB - where the instructions start.
*****************************************************************************/
build();

/*****************************************************************************
MODULES: - the meat of the project.
*****************************************************************************/
module build()
{
    difference()
    {
        J_Brace();

        //screw hole for spacer.
        translate([half(FLOOR_WIDTH), 0, half(BRACE_WIDTH)]) 
        rotate([90, 0, 0]) 
        cylinder(h = 100,d = 5, $fn=100, center = true);

        //screw hole for truss
        translate([FLOOR_WIDTH, half(TRUSS_HEIGHT), half(BRACE_WIDTH)]) 
        rotate([0, 90, 0]) 
        cylinder(h = 100,d = 5, $fn=100, center = true);
    }
}


module J_Brace() {
    
    difference()
    {
        union()
        {
           linear_extrude(BRACE_WIDTH)
            {
                // translate([150, 0, 0]) 
                {
                    color("Aqua") 
                    rotate([0, 0, 5])
                    translate([0.3,1.8* BRACE_THICKNESS, 0]) 
                    square(size=[BRACE_THICKNESS,(WALL_HEIGHT-3*BRACE_THICKNESS)]);

                    color("LightCyan")
                    translate([1.8*BRACE_THICKNESS, 0, 0]) 
                    rotate([0, 0, 5]) 
                    square(size=[(FLOOR_WIDTH-BRACE_THICKNESS),BRACE_THICKNESS]);

                    color("PaleTurquoise") 
                    translate([FLOOR_WIDTH-2, 0, 0])     
                    rotate([0, 0, -5]) 
                    {
                        square(size=[BRACE_THICKNESS,TRUSS_HEIGHT]);
                    }
                }
            }

            color("Turquoise") 
            translate([2*BRACE_THICKNESS-0.7, 2*BRACE_THICKNESS, 0]) 
            rotate([0, 0, 180]) 
            rotate_extrude(angle = 90)
            translate([BRACE_THICKNESS, 0, 0]) 
            {
                square(size=[BRACE_THICKNESS, BRACE_WIDTH]);
            }
        }

        #rotate([0, 0, 2])
        translate([-2, WALL_HEIGHT-BRACE_THICKNESS, 0]) 
        rotate([0, 0, 182])
        scale([8,half(WALL_HEIGHT),BRACE_WIDTH]) 
        linear_extrude(height =1) 
        polygon(TRIANGLE);
    }
}