/*
Description : <what does this do?>
*/

/*****************************************************************************
CONSTANTS
*****************************************************************************/
$fn=100;
PI = 4 * atan2(1,1);
DS_HEIGHT = 57;
DS_WIDTH = 80;
DS_RADIUS = 15.5;
DS_WALL = 4;
TUBE_HEIGHT = 10;

/*****************************************************************************
FUNCTIONS - code to make reading modules easier to understand.
******************************************************************************/
function minkowskiAdj(x, r) = x - 2*r;

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
    // #square([DS_HEIGHT,DS_WIDTH],center = true);
    // linear_extrude(height = TUBE_HEIGHT, center = true, convexity = 10)
    difference()
    {
        minkowski()
        {
            square([minkowskiAdj(DS_HEIGHT,DS_RADIUS)+DS_WALL,minkowskiAdj(DS_WIDTH,DS_RADIUS)+DS_WALL],center = true);
            circle(DS_RADIUS);
        }

        minkowski()
        {
            square([minkowskiAdj(DS_HEIGHT,DS_RADIUS),minkowskiAdj(DS_WIDTH,DS_RADIUS)],center = true);
            circle(DS_RADIUS);
        }
    }
}

module downSpout(height, width, radius, wall)
{
    difference()
    {
        minkowski()
        {
            square([minkowskiAdj(DS_HEIGHT)+DS_WALL,minkowskiAdj(DS_WIDTH)+DS_WALL],center = true);
            circle(DS_RADIUS);
        }

        minkowski()
        {
            square([minkowskiAdj(DS_HEIGHT),minkowskiAdj(DS_WIDTH)],center = true);
            circle(DS_RADIUS);
        }
    }
}