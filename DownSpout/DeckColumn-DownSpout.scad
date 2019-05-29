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
FEMALE_HEIGHT = 42.2-FEMALE_RADIUS;
FEMALE_WIDTH = 64.2-FEMALE_RADIUS;
DS_WALL = 3;
TUBE_LENGTH = 50;
CONNECTOR_LENGTH = 60;
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
INCLUDE_CHANNEL = 1;
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
    color("Aqua") translate([0,-120,0])
    // rotate([180,0,0])
    mirror([1,0,0])
    S_horizontal_downspout_connector();
    
    //along post
    color("green") translate([TIGHT_ELBOW_90_OFFSET*1.5, CONNECTOR_LENGTH, 0]) 
    difference()
    {
        rotate([90,0,0])
        downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, CONNECTOR_LENGTH);
    }
    color("blue") translate([0, CONNECTOR_LENGTH, 0]) 
    S_horizontal_downspout_connector();

    //post
    // translate([-40,30, 100-FEMALE_HEIGHT])
    // cube(size=[WOOD_NOMINAL_SIZE_4IN, WOOD_NOMINAL_SIZE_4IN, 200], center=true);

}

module S_horizontal_downspout_connector() 
{
    
    translate([0, ELBOW_90_OFFSET + half(120), 0]) 
    rotate([0, 0, 180]) 
    difference()
    {
        Horizontal_Downspout_Elbow();
        if(INCLUDE_CHANNEL) elbowChannel();
    }

    difference()
    {
        Horizontal_Downspout_Elbow();
        if(INCLUDE_CHANNEL) elbowChannel();
    }
}

module  Horizontal_Downspout_Elbow(right = 1)
{
    
    rotate_extrude(angle=right * ELBOW_ANGLE,convexity = 10)
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
            union()
            {
                offset(r = radius-wall) square(dimensions,center = true);
                if(INCLUDE_CHANNEL)
                {
                    translate([0,30,0])
                    square([dimensions[0]+2*wall+2,dimensions[0]],center = true);
                }
            }
        }
    }
}

module elbowChannel(right = 1)
{
    translate([0,0,30])
    rotate_extrude(angle=right * ELBOW_ANGLE,convexity = 10)
    translate([ELBOW_90_OFFSET, 0, 0])
    offset(r = FEMALE_RADIUS-DS_WALL) square(15,center = true);
}