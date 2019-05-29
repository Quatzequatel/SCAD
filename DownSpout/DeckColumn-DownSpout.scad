/*
Description : 
    Issue is that deck-wall posts are in the way of continuous downspout.
    Workaround is to create a low profile attachment to go around the post.
*/

/*****************************************************************************
CONSTANTS
*****************************************************************************/
$fn=100;
PI = 4 * atan2(1,1);
ELBOW_90_OFFSET = 60;
TIGHT_ELBOW_90_OFFSET = 40;
ELBOW_ANGLE = 90;
FEMALE_RADIUS = 21;
FEMALE_HEIGHT = 64.2-FEMALE_RADIUS;
FEMALE_WIDTH = 42.2-FEMALE_RADIUS;
DS_WALL = 3;
TUBE_LENGTH = 50;
CONNECTOR_LENGTH = 50;
FEMALE_DEMS = [FEMALE_WIDTH,FEMALE_HEIGHT];
MALE_RADIUS = 18;
MALE_HEIGHT = FEMALE_HEIGHT-7;
MALE_WIDTH = FEMALE_WIDTH-8;
MALE_DEMS = [MALE_WIDTH,MALE_HEIGHT];
WOOD_NOMINAL_SIZE_4IN = 89;

/*****************************************************************************
FUNCTIONS - code to make reading modules easier to understand.
******************************************************************************/
function half(x) = x/2;
function swap(arr) = [arr[1],arr[0]];
function actualWidth(length, radius, wall) = TIGHT_ELBOW_90_OFFSET;

/*****************************************************************************
Directives - defines what to build with optional features.
*****************************************************************************/
INCLUDE_CHANNEL = 0;
BUILD_POST_CONNECTOR = 1;

/*****************************************************************************
MAIN SUB - where the instructions start.
*****************************************************************************/
build();

/*****************************************************************************
MODULES: - the meat of the project.
*****************************************************************************/
module build()
{
    if(BUILD_POST_CONNECTOR) postConnector();

}

module postConnector() 
{
    //four 90 degree  elbows to go around post. _|-|_
    translate([0,-10,0])
    rotate([180,0,0])
    S_horizontal_downspout_connector();
    
    translate([TIGHT_ELBOW_90_OFFSET*1.5, TIGHT_ELBOW_90_OFFSET, 0]) 
    rotate([90,0,0])
    downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, CONNECTOR_LENGTH);

    translate([0, TIGHT_ELBOW_90_OFFSET, 0]) 
    S_horizontal_downspout_connector();

    translate([-20,20, 100-FEMALE_HEIGHT])
    cube(size=[WOOD_NOMINAL_SIZE_4IN, WOOD_NOMINAL_SIZE_4IN, 200], center=true);

}

module S_horizontal_downspout_connector() 
{
    
    translate([0, ELBOW_90_OFFSET + half(120), 0]) 
    rotate([0, 0, 180]) 
    Horizontal_Downspout_Elbow();

    Horizontal_Downspout_Elbow();
}

module  Horizontal_Downspout_Elbow(right = 1)
{
    
    color("Aqua")rotate_extrude(angle=right * ELBOW_ANGLE,convexity = 10)
    translate([ELBOW_90_OFFSET, 0, 0])
    difference()
    {
        offset(r = FEMALE_RADIUS) square(FEMALE_DEMS,center = true);
        offset(r = FEMALE_RADIUS-DS_WALL) square(FEMALE_DEMS,center = true);
    }
}

module  Vertical_Downspout_Elbow()
{
    union()
    {
        rotate([90,90,0])
        {
            color("Aqua")
            rotate_extrude(angle=ELBOW_ANGLE,convexity = 10)
            translate([TIGHT_ELBOW_90_OFFSET, 0, 0])
            difference()
            {
                offset(r = FEMALE_RADIUS) square(swap(FEMALE_DEMS),center = true);
                offset(r = FEMALE_RADIUS-DS_WALL) square(swap(FEMALE_DEMS),center = true);
            }
        }

        translate([actualWidth(FEMALE_HEIGHT,FEMALE_RADIUS,DS_WALL), 0, 0]) 
        rotate([0,0,90])
        downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, CONNECTOR_LENGTH);

        translate([-ELBOW_90_OFFSET+10, 0,-40]) 
        rotate([90,0,90])
        downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, CONNECTOR_LENGTH);
    }
}

module downSpout(dimensions, radius, wall, length)
{
    linear_extrude(height = length)
    {
        difference()
        {
            offset(r = radius) square(dimensions,center = true);
            offset(r = radius-wall) square(dimensions,center = true);
        }
    }
}
