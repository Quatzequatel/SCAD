/*
Description : File for building parts used in deck assembly
*/

/*****************************************************************************
CONSTANTS
*****************************************************************************/
$fn=100;
PI = 4 * atan2(1,1);
INCH = 25.4;
THREE_SIXTEENTHS_INCH = 4.7625;
QUARTER_INCH = 6.35;
DECKING_GAP = THREE_SIXTEENTHS_INCH;
WALL_GAP = INCH / 2;

/*****************************************************************************
FUNCTIONS - code to make reading modules easier to understand.
******************************************************************************/
function half(x) = x/2;

/*****************************************************************************
Directives - defines what to build with optional features.
*****************************************************************************/
INCLUDE_THING = 0;
BUILD_THING = 1;
BUILD_DECKING_GAP_SPACER = 1;
BUILD_WALL_GAP_SPACER = 0;

/*****************************************************************************
MAIN SUB - where the instructions start.
*****************************************************************************/
build();

/*****************************************************************************
MODULES: - the meat of the project.
*****************************************************************************/
module build()
{
    if (BUILD_DECKING_GAP_SPACER) 
    {
        decking_gap_spacer();

    }
    else if(BUILD_WALL_GAP_SPACER)
    {
        Wall_gap_spacer();
        // translate([INCH,0,0])
        // rotate([90,0,0])
        // #cylinder(r=1, h=WALL_GAP, center=true);
    }
}

module decking_gap_spacer()
{
    //spacer to fit in between boards.
    translate([INCH * 0.75, 0, 0]) 
    // rotate([90, 0, 0]) 
    linear_extrude(height = INCH, slices = 60) 
    resize([INCH, DECKING_GAP, 0], auto = [false,true,false])
    offset( r = half(INCH), chamfer =false) 
    square(size=[INCH, DECKING_GAP], center=true);

    //handle to grip with
    linear_extrude(height = INCH) square(size=[INCH, 2*INCH], center=true);
}

module Wall_gap_spacer()
{
    //spacer to fit in between boards.
    translate([INCH * 0.75, 0, 0]) 
    // rotate([90, 0, 0]) 
    linear_extrude(height = INCH, slices = 60) 
    resize([INCH,WALL_GAP,0], auto = [true,true,false])
    offset( r = half(INCH), chamfer =false) 
    square(size=[INCH, WALL_GAP], center=true);

    //handle to grip with
    translate([0, half(1.5*INCH) - half(WALL_GAP), 0]) 
    linear_extrude(height = INCH) square(size=[INCH, 1.5*INCH], center=true);
}