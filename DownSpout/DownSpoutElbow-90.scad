/*
Description : 90 degree elbow joint for a flat downspout.
still in progress need to validate dimensions are corrrect. 
*/

/*****************************************************************************
CONSTANTS
*****************************************************************************/
$fn=100;
PI = 4 * atan2(1,1);
ELBOW_90_OFFSET = 60;
ELBOW_ANGLE = 90;
FEMALE_RADIUS = 21;
FEMALE_HEIGHT = 42.2-FEMALE_RADIUS;
FEMALE_WIDTH = 64.2-FEMALE_RADIUS;
DS_WALL = 3;
TUBE_LENGTH = 50;
CONNECTOR_LENGTH = 50;
FEMALE_DEMS = [FEMALE_WIDTH,FEMALE_HEIGHT];
MALE_RADIUS = 18;
MALE_HEIGHT = FEMALE_HEIGHT-7;
MALE_WIDTH = FEMALE_WIDTH-8;
MALE_DEMS = [MALE_WIDTH,MALE_HEIGHT];

/*****************************************************************************
FUNCTIONS - code to make reading modules easier to understand.
******************************************************************************/
function half(x) = x/2;

/*****************************************************************************
Directives - defines what to build with optional features.
*****************************************************************************/
INCLUDE_CHANNEL = 1;
BUILD_MALE_CONNECTOR = 0;
BUILD_ELBOW_CONNECTOR = 0;
BUILD_STRAIGHT_CONNECTOR = 0;
BUILD_T_TUBE = 1;

/*****************************************************************************
MAIN SUB - where the instructions start.
*****************************************************************************/
build();

/*****************************************************************************
MODULES: - the meat of the project.
*****************************************************************************/
module build()
{
    if(BUILD_ELBOW_CONNECTOR) elbowConnector();
    if(BUILD_MALE_CONNECTOR) maleConnector();
    if(BUILD_STRAIGHT_CONNECTOR) straightConnector();
    if(BUILD_T_TUBE) ttubeConnector();
}

module elbowConnector()
{
    difference()
    {
        union()
        {
            translate([ELBOW_90_OFFSET,0,0])
            rotate([90,0,0])
            downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, CONNECTOR_LENGTH);

            elbow();

            translate([-50,ELBOW_90_OFFSET,0])
            rotate([90,0,90])
            downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, CONNECTOR_LENGTH);
        }
        if(INCLUDE_CHANNEL) union()
        {
            elbowChannel();
            channel();
        }
    }
}

module ttubeConnector()
{
    difference()
    {
        union()
        {
            elbow();
            translate([0,FEMALE_WIDTH+FEMALE_RADIUS+ELBOW_90_OFFSET-DS_WALL-2,0])
            elbow(-1);
        }

        union()
        {
            elbowChannel();
            rotate_extrude(angle=ELBOW_ANGLE,convexity = 10)
            translate([ELBOW_90_OFFSET, 0, 0])
            offset(r = FEMALE_RADIUS-DS_WALL) square(FEMALE_DEMS,center = true);
            translate([0,FEMALE_WIDTH+FEMALE_RADIUS+ELBOW_90_OFFSET-DS_WALL,0])
            elbowChannel(-1);         

            translate([0,FEMALE_WIDTH+FEMALE_RADIUS+ELBOW_90_OFFSET-DS_WALL,0])
            rotate_extrude(angle=-1 * ELBOW_ANGLE,convexity = 10)
            translate([ELBOW_90_OFFSET, 0, 0])
            offset(r = FEMALE_RADIUS-DS_WALL) square(FEMALE_DEMS,center = true);
   
        }
    }

    
    difference()
    {
        union()
        {
            translate([ELBOW_90_OFFSET,0,0])
            rotate([90,0,0])
            downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, CONNECTOR_LENGTH);

            translate([ELBOW_90_OFFSET,168,0])
            rotate([90,0,0])
            downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, CONNECTOR_LENGTH);

            translate([-50,ELBOW_90_OFFSET-0.1,0])
            rotate([90,0,90])
            downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, CONNECTOR_LENGTH);
        }

        channel(1);
    }
}

module straightConnector()
{
    rotate([90,0,0])
    difference()
    {
        downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, 2*CONNECTOR_LENGTH);

        translate([0,30,-1])
        linear_extrude(height=3*CONNECTOR_LENGTH)
        offset(r = FEMALE_RADIUS-DS_WALL) square(15,center = true);

    }
    
}

module channel(forT = 0)
{
    color("LightCyan")
    translate([60,-TUBE_LENGTH,30])
    rotate([0,90,90])
    linear_extrude(height=CONNECTOR_LENGTH)
    offset(r = FEMALE_RADIUS-DS_WALL) square(15,center = true);

    color("Aqua")
    translate([-TUBE_LENGTH,ELBOW_90_OFFSET,30])
    rotate([0,90,0])
    linear_extrude(height=CONNECTOR_LENGTH)
    offset(r = FEMALE_RADIUS-DS_WALL) square(15,center = true);

    if(forT)
    {
        color("PaleTurquoise")
        translate([60,118,30])
        rotate([0,90,90])
        linear_extrude(height=CONNECTOR_LENGTH)
        offset(r = FEMALE_RADIUS-DS_WALL) square(15,center = true);
    }
}

module elbowChannel(right = 1)
{
    translate([0,0,30])
    rotate_extrude(angle=right * ELBOW_ANGLE,convexity = 10)
    translate([ELBOW_90_OFFSET, 0, 0])
    offset(r = FEMALE_RADIUS-DS_WALL) square(15,center = true);
}

module maleConnector(length)
{
    // downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, TUBE_LENGTH)

    difference()
    {
        union()
        {
            linear_extrude(height = DS_WALL) offset(r = FEMALE_RADIUS) square(FEMALE_DEMS,center = true);
            downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, TUBE_LENGTH
        );

            translate([0, 0, -TUBE_LENGTH
        ])
            downSpout(MALE_DEMS,FEMALE_RADIUS,DS_WALL, TUBE_LENGTH
        );
        }

        translate([0, 0, -1])
        linear_extrude(height = 2*DS_WALL) offset(r = FEMALE_RADIUS-DS_WALL) square(MALE_DEMS,center = true);
    }
}

module  elbow(right = 1)
{
    rotate_extrude(angle=right * ELBOW_ANGLE,convexity = 10)
    translate([ELBOW_90_OFFSET, 0, 0])
    difference()
    {
        offset(r = FEMALE_RADIUS) square(FEMALE_DEMS,center = true);
        offset(r = FEMALE_RADIUS-DS_WALL) square(FEMALE_DEMS,center = true);
    }
}

module downSpout(dimensions, radius, wall, length)
{
    linear_extrude(height = length)
    difference()
    {
        offset(r = radius) square(dimensions,center = true);
        offset(r = radius-wall) square(dimensions,center = true);
    }
}
