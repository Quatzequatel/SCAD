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
//2x4 wood = TWOx4W
TWOx4W_WIDTH = 91; //adding 2mm having issues with brakets snapping.
TWOx4W_HEIGHT = 38.1;
TWOx4W_DIMENSIONS = [TWOx4W_HEIGHT,TWOx4W_WIDTH];

BASE_OFFSET = TD_HEIGHT + WALL + TWOx4W_HEIGHT + WALL;

SPACER_HEIGHTS=[38,32,25,19,13,6];
SPACER_HEIGHTS_OFFSETS=[0,-2,-8,-20,-38,-60];
SPACER_SIZE_VALUES=[4,8,13,19,25,32,38];

SMALL_METRIC_HEIGHTS = [0,10,15,20,25,30];
SMALL_METRIC_OFFSETS = [0,-35,-60,-85,-100,-110];

LARGE_METRIC_HEIGHTS = [30,35,40,45,50,55];
LARGE_METRIC_OFFSETS = [10,0,0,0,10,20];

MAX_COUNTS = [7,6,5,5,4,4,3];


/*****************************************************************************
FUNCTIONS - code to make reading modules easier to understand.
******************************************************************************/
function half(x) = x/2;
function adjust_dimensions_wall(dimensions, wall) = [dimensions[0]+(2*wall),dimensions[1]+(2*wall)];
function adjustedSpacerHeight(height, wall) = (height > 2*wall) ? height - (2*wall): 0;
function maxCountforSize(size) = MAX_COUNTS[size];
//get the acctual build length
function buildLength(size, count) = ((count + 1) * spacerLength(size)) + TWOx4W_HEIGHT + SPACER_SIZE_VALUES[size] - WALL;
//length for spacer for tight layout.
function spacerLength(size) = TWOx4W_HEIGHT + SPACER_SIZE_VALUES[size];

function getSizeOfSet(index) = SET_DEFINED[index][0];
function getCountOfSet(index) = SET_DEFINED[index][1];
//get spacer length for groups.
function groupSpacerLength(index) = index == 0 ? ((getCountOfSet(0) + 1) * spacerLength(getSizeOfSet(0))) + 5 :
            (
                (getSizeOfSet(index) + 1) * spacerLength(getSizeOfSet(index)) + 
                groupSpacerLength(index-1)
            ) + 5 ;

/*****************************************************************************
Directives - defines what to build with optional features.
*****************************************************************************/
INCLUDE_THING = 0;
BUILD_SUIT = 0; //current set in use.
BUILD_SINGLE_SMALL = 0;
BUILD_SET = 2; //0 = do nothing; 1 = single BUILD_SIZE set; 2 = set of SET_DEFINED.
BUILD_SIZE = 5;
BUILD_COUNT = MAX_COUNTS[BUILD_SIZE];
SET_DEFINED = [[3,1],[4,0]];
BUILD_SIDE_SET = 1;
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

    if(BUILD_SET ==1) 
    {
        translate([TWOx4W_HEIGHT + SPACER_SIZE_VALUES[BUILD_SIZE] - WALL, 0, 0]) 
        build_single_set(BUILD_SIZE, BUILD_COUNT);
    }
    if(BUILD_SET > 1)
    {
        build_single_set(getSizeOfSet(0), getCountOfSet(0));
        
        if(getSizeOfSet(1)> 0)
        {
            translate([groupSpacerLength(0), 0, 0])
            build_single_set(getSizeOfSet(1), getCountOfSet(1));
        }

        if(getSizeOfSet(2)> 0)
        {
            translate([groupSpacerLength(1), 0, 0])
            build_single_set(getSizeOfSet(2), getCountOfSet(2));        
        }

        if(getCountOfSet(3)> 0)
        {
            translate([groupSpacerLength(2), 0, 0])
            build_single_set(getSizeOfSet(3), getCountOfSet(3));        
        }
    }

    if(BUILD_WAVE_SPACER) buildWaveSpacer();
    
}

module buildWaveSpacer() 
{
    Side_Stacked_Bracket(13);
}

module build_single_set(size, count) 
{
    echo(size=size, count=count, spacerLength=spacerLength(size), buildLength=buildLength(size,count));
    for (i=[0:count]) 
    {
        if(BUILD_SIDE_SET)
        {
            translate([(i * spacerLength(size)) , i%2 != 0 ? WALL*2 : 0, 0]) 
            Side_Stacked_Bracket(SPACER_SIZE_VALUES[size]);
        }
        else
        {
            translate([(i * spacerLength(size)) , 0, 0]) 
            H_Bracket(SPACER_SIZE_VALUES[size]);            
        }

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
        color("Aqua") spacer(TWOx4W_DIMENSIONS, BRACKET_LENGTH, adjustedSpacerHeight(spacerHeight,WALL));

        translate([-(0.5 * TWOx4W_HEIGHT + 2*WALL + adjustedSpacerHeight(spacerHeight,WALL)), 0, 0]) 
        rotate([0, 0, 180])         
        u_bracket(TWOx4W_DIMENSIONS, WALL, BRACKET_LENGTH );
    }
    else
    {
        translate([-(0.5 * TWOx4W_HEIGHT + WALL), 0, 0]) 
        rotate([0, 0, 180])         
        color("LightCyan") u_bracket(TWOx4W_DIMENSIONS, WALL, BRACKET_LENGTH );
    }
}

module Side_Stacked_Bracket(spacerHeight)
{
    //TD bracket.
    translate([0.5*TD_HEIGHT, 0, 0]) 
    u_bracket(TD_DIMENSIONS, WALL, BRACKET_LENGTH );

    if (spacerHeight > WALL) 
    {
        translate([-(WALL + adjustedSpacerHeight(spacerHeight,WALL)/2), half(TD_WIDTH-TWOx4W_WIDTH), 0]) 
        color("Aqua") spacer(TWOx4W_DIMENSIONS, BRACKET_LENGTH, adjustedSpacerHeight(spacerHeight,WALL));

        //TWOx4W
        translate([-(0.5 * TWOx4W_HEIGHT + 2*WALL + adjustedSpacerHeight(spacerHeight,WALL)), half(TD_WIDTH-TWOx4W_WIDTH), 0]) 
        rotate([0, 0, 180])         
        u_bracket(TWOx4W_DIMENSIONS, WALL, BRACKET_LENGTH );
    }
    else
    {
        translate([-(0.5 * TWOx4W_HEIGHT + WALL), half(TD_WIDTH-TWOx4W_WIDTH), 0]) 
        rotate([0, 0, 180])         
        color("LightCyan") u_bracket(TWOx4W_DIMENSIONS, WALL, BRACKET_LENGTH );
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