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
function wedgeIncrement(height,i) = i * half(height)/(BRACE_THICKNESS)+half(height);

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
    //staggaredWall(WALL_HEIGHT-3*BRACE_THICKNESS);
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

module staggaredWall(height=WALL_HEIGHT)
{
    echo(str("height = ", height));
    translate([BRACE_THICKNESS+0.3, 1.8* BRACE_THICKNESS, BRACE_WIDTH]) 
    rotate([0, 180, 5]) 
    linear_extrude(BRACE_WIDTH)
    {
        for (i=[1:(BRACE_THICKNESS)]) {
            echo(str("wedgeIncrement(i)=", wedgeIncrement(height,i)));
            translate([i, 0, 0]) 
            square(size=[1,wedgeIncrement(height,i)], center = false);
        }        
    }    
}

module J_Brace() {
    
    difference()
    {
        union()
        {
            staggaredWall(height=WALL_HEIGHT-3*BRACE_THICKNESS);
            linear_extrude(BRACE_WIDTH)
            {
                {
                    //floor
                    color("LightCyan")
                    translate([1.8*BRACE_THICKNESS, 0, 0]) 
                    // rotate([0, 0, 5]) 
                    square(size=[(FLOOR_WIDTH-BRACE_THICKNESS),BRACE_THICKNESS]);

                    //truss side
                    color("PaleTurquoise") 
                    translate([FLOOR_WIDTH, 0, 0])     
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

    }
}