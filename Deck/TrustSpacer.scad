/*
Description : creates spacer brackets used on roof deck trusses. between the 
trekdeck board and treated 2x4. used to keep 2x4 level.
*/

/*****************************************************************************
CONSTANTS
*****************************************************************************/
$fn=100;
PI = 4 * atan2(1,1);
SCREW_RADIUS = 3;

//TreakDeck = TD
TD_WIDTH = 141;
TD_HEIGHT = 31;
TD_RADIUS = 16;
TD_DIMENSIONS = [TD_HEIGHT,TD_WIDTH];
WALL = 4;
BRACKET_LENGTH = 19;
//2x4 wood = TO4W
TO4W_WIDTH = 91; //adding 2mm having issues with brakets snapping.
TO4W_HEIGHT = 38.1;
TO4W_DIMENSIONS = [TO4W_HEIGHT,TO4W_WIDTH];

BASE_OFFSET = TD_HEIGHT + WALL + TO4W_HEIGHT + WALL;

SPACER_HEIGHTS=[38,32,25,19,13,6];
SPACER_HEIGHTS_OFFSETS=[0,-2,-8,-20,-38,-60];
SPACER_SIZE_VALUES=[4,8,13,19,25,32,38];

SMALL_METRIC_HEIGHTS = [0,10,15,20,25,30];
SMALL_METRIC_OFFSETS = [0,-35,-60,-85,-100,-110];

LARGE_METRIC_HEIGHTS = [30,35,40,45,50,55];
LARGE_METRIC_OFFSETS = [10,0,0,0,10,20];

MAX_COUNTS = [7,6,5,5,4,4,3];
OFFSET_MAX_BUILD = [35,30,20,19,13,7,4];


/*****************************************************************************
FUNCTIONS - code to make reading modules easier to understand.
******************************************************************************/
function half(x) = x/2;
function adjust_dimensions_wall(dimensions, wall) = [dimensions[0]+(2*wall),dimensions[1]+(2*wall)];
function adjustedSpacerHeight(height, wall) = (height > 2*wall) ? height - (2*wall): 0;
function maxCountforSize(size) = MAX_COUNTS[size];
function maxOffsetForSize(size) = OFFSET_MAX_BUILD[size];
//get the acctual build length
function buildLength(size, count) = ((count + 1) * spacerLength(size)) + TO4W_HEIGHT + SPACER_SIZE_VALUES[size] - WALL;
//length for spacer for tight layout.
function spacerLength(size) = TO4W_HEIGHT + SPACER_SIZE_VALUES[size];
function getSizeOfSet(index) = SET_DEFINED[index][0];
function getCountOfSet(index) = SET_DEFINED[index][1];

/*****************************************************************************
Directives - defines what to build with optional features.
*****************************************************************************/
INCLUDE_THING = 0;
BUILD_SUIT = 0; //current set in use.
BUILD_SMALL_METRIC_SUIT = 0; //may want to try a set of these
BUILD_LARGE_METRIC_SUIT = 0; //set of these.s
BUILD_SINGLE_SMALL = 0;
BUILD_SET = 2;
BUILD_SIZE = 5;
BUILD_COUNT = MAX_COUNTS[BUILD_SIZE];
SET_DEFINED = [[3,2],[4,2]];
BUILD_WAVE_SPACER = 0;

/*****************************************************************************
MAIN SUB - where the instructions start.
*****************************************************************************/
build();

/*****************************************************************************
MODULES: - the meat of the project.
*****************************************************************************/
module build()
{
    if(BUILD_SINGLE_SMALL) H_Bracket(SPACER_SIZE_VALUES[BUILD_SIZE]);
    if(BUILD_SUIT) create_suit(SPACER_HEIGHTS, SPACER_HEIGHTS_OFFSETS,5,2);
    if(BUILD_SMALL_METRIC_SUIT) create_suit(SMALL_METRIC_HEIGHTS, SMALL_METRIC_OFFSETS);
    //modify max (4) to fit in printer.
    if(BUILD_LARGE_METRIC_SUIT) create_suit(LARGE_METRIC_HEIGHTS, LARGE_METRIC_OFFSETS, 4);
    if(BUILD_SET ==1) 
    {
        translate([TO4W_HEIGHT + SPACER_SIZE_VALUES[BUILD_SIZE] - WALL, 0, 0]) 
        build_single_set(BUILD_SIZE, BUILD_COUNT);
    }
    if(BUILD_SET > 1)
    {
        build_single_set(getSizeOfSet(0), getCountOfSet(0));
        // echo(length = buildLength(getSizeOfSet(0), getCountOfSet(0), one = SET_DEFINED[0][0], two = SET_DEFINED[0][1]);
        translate([((SET_DEFINED[0][1] + 1) * spacerLength(SET_DEFINED[0][0]) + 5), 0, 0])
        build_single_set(getSizeOfSet(1), getCountOfSet(1));

        // translate([230 , 0, 0])
        // build_single_set(SET_DEFINED[2][0], SET_DEFINED[2][1]);
    }

    if(BUILD_WAVE_SPACER) buildWaveSpacer();
    // if(!BUILD_SUIT && !BUILD_SMALL_METRIC_SUIT && !BUILD_LARGE_METRIC_SUIT) H_Bracket(0);
}

module buildWaveSpacer() 
{
    
}

module build_single_set(size, count) 
{
    echo(size=size, count=count, spacerLength=spacerLength(size), buildLength=buildLength(size,count));
    for (i=[0:count]) 
    {
        translate([(i * spacerLength(size)) , 0, 0]) 
        H_Bracket(SPACER_SIZE_VALUES[size]);
    }
}

module build_set(set) 
{
    
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

    if (spacerHeight > WALL) 
    {
        translate([-(WALL + adjustedSpacerHeight(spacerHeight,WALL)/2), 0, 0]) 
        color("Aqua") spacer(TO4W_DIMENSIONS, BRACKET_LENGTH, adjustedSpacerHeight(spacerHeight,WALL));

        translate([-(0.5 * TO4W_HEIGHT + 2*WALL + adjustedSpacerHeight(spacerHeight,WALL)), 0, 0]) 
        rotate([0, 0, 180])         
        u_bracket(TO4W_DIMENSIONS, WALL, BRACKET_LENGTH );
    }
    else
    {
        translate([-(0.5 * TO4W_HEIGHT + WALL), 0, 0]) 
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