/*
Description : creates spacer brackets used on roof deck trusses. between the 
trekdeck board and treated 2x4. used to keep 2x4 level.
*/

/*****************************************************************************
CONSTANTS
*****************************************************************************/
$fn=100;
PI = 4 * atan2(1,1);
SCREW_RADIUS = 1.6;

//TreakDeck = TD
TD_WIDTH = 141;
TD_HEIGHT = 31;
TD_RADIUS = 16;
TD_DIMENSIONS = [TD_HEIGHT,TD_WIDTH];
WALL = 4;
BRACKET_LENGTH = 26;
//2x4 wood = TO4W
TO4W_WIDTH = 88.9;
TO4W_HEIGHT = 38.1;
TO4W_DIMENSIONS = [TO4W_HEIGHT,TO4W_WIDTH];

BASE_OFFSET = TD_HEIGHT + WALL + TO4W_HEIGHT + WALL;

SPACER_HEIGHTS=[38,32,25,19,13,6];
SPACER_HEIGHTS_OFFSETS=[0,-2,-8,-20,-38,-60];

SMALL_METRIC_HEIGHTS = [0,10,15,20,25,30];
SMALL_METRIC_OFFSETS = [0,-35,-60,-85,-100,-110];

LARGE_METRIC_HEIGHTS = [30,35,40,45,50,55];
LARGE_METRIC_OFFSETS = [10,0,0,0,10,20];


/*****************************************************************************
FUNCTIONS - code to make reading modules easier to understand.
******************************************************************************/
function half(x) = x/2;
function adjust_dimensions_wall(dimensions, wall) = [dimensions[0]+(2*wall),dimensions[1]+(2*wall)];
function adjustedSpacerHeight(height, wall) = (height > 2*wall) ? height - (2*wall): 0;

/*****************************************************************************
Directives - defines what to build with optional features.
*****************************************************************************/
INCLUDE_THING = 0;
BUILD_SUIT = 1; //current set in use.
BUILD_SMALL_METRIC_SUIT = 0; //may want to try a set of these
BUILD_LARGE_METRIC_SUIT = 0; //set of these.s

/*****************************************************************************
MAIN SUB - where the instructions start.
*****************************************************************************/
build();

/*****************************************************************************
MODULES: - the meat of the project.
*****************************************************************************/
module build()
{
    if(BUILD_SUIT) create_suit(SPACER_HEIGHTS, SPACER_HEIGHTS_OFFSETS,5,2);
    if(BUILD_SMALL_METRIC_SUIT) create_suit(SMALL_METRIC_HEIGHTS, SMALL_METRIC_OFFSETS);
    //modify max (4) to fit in printer.
    if(BUILD_LARGE_METRIC_SUIT) create_suit(LARGE_METRIC_HEIGHTS, LARGE_METRIC_OFFSETS, 4);
    if(!BUILD_SUIT && !BUILD_SMALL_METRIC_SUIT && !BUILD_LARGE_METRIC_SUIT) H_Bracket(10);
}

module create_suit(heights, customOffsets, max = 5, min = 0) {
    
    for ( i = [min:max]) 
    {
        echo(i,SPACER_HEIGHTS[i]);
        translate([(i * BASE_OFFSET) + heights[i] + customOffsets[i], 0, 0]) 
        H_Bracket(heights[i]);
    }
}

module H_Bracket(spacerHeight)
{
    translate([0.5*TD_HEIGHT, 0, 0]) 
    u_bracket(TD_DIMENSIONS, WALL, BRACKET_LENGTH );

    if (spacerHeight > 2 * WALL) 
    {
        translate([-(WALL + adjustedSpacerHeight(spacerHeight,WALL)/2), 0, 0]) 
        color("Aqua") spacer(TO4W_DIMENSIONS, BRACKET_LENGTH, adjustedSpacerHeight(spacerHeight,WALL));

        translate([-(0.5 * TO4W_HEIGHT + 2*WALL + adjustedSpacerHeight(spacerHeight,WALL)), 0, 0]) 
        rotate([0, 0, 180])         
        u_bracket(TO4W_DIMENSIONS, WALL, BRACKET_LENGTH );
    }
    else
    {
        translate([-(0.5 * TO4W_HEIGHT + 2*WALL), 0, 0]) 
        rotate([0, 0, 180])         
        color("LightCyan") u_bracket(TO4W_DIMENSIONS, WALL, BRACKET_LENGTH );
    }
}

module u_bracket(dimensions, wall, length)
{
    difference()
    {
        linear_extrude(height = length)
        difference()
        {
            square(adjust_dimensions_wall(dimensions, wall),center = true);

            square(dimensions,center = true);
            translate([0.5*dimensions[0], -1, 0]) 
            {
                square([2*wall,adjust_dimensions_wall(dimensions, wall)[1]+wall], center = true);    
            }
        }
        
        //create screwhole
        translate([-4, 0, length/2]) 
        rotate([90, 0, 0]) 
        {
            cylinder(r=SCREW_RADIUS, h=dimensions[1]*1.5, center=true);            
        }
    }
}

///
module spacer(dimensions, length, value) 
{
    linear_extrude(height = length)
    square([value,adjust_dimensions_wall(dimensions,WALL)[1]],center = true);
}