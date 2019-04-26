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
    elbowConnector();
    // downSpout(DS_DEMS,FEMALE_RADIUS,DS_WALL, 15);
    // draw([1,1.02,5],[0,0,0],downSpoutPoints,DS_WALL,1);
// maleConnector();

    // elbowChannel();
    // channel();
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

module channel()
{
    color("Aqua")
    translate([60,-TUBE_LENGTH,30])
    rotate([0,90,90])
    linear_extrude(height=CONNECTOR_LENGTH)
    offset(r = FEMALE_RADIUS-DS_WALL) square(15,center = true);

    color("Aqua")
    translate([-TUBE_LENGTH,ELBOW_90_OFFSET,30])
    rotate([0,90,0])
    linear_extrude(height=CONNECTOR_LENGTH)
    offset(r = FEMALE_RADIUS-DS_WALL) square(15,center = true);
}

module elbowChannel()
{
    translate([0,0,30])
    rotate_extrude(angle=ELBOW_ANGLE,convexity = 10)
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

module  elbow()
{
    rotate_extrude(angle=ELBOW_ANGLE,convexity = 10)
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

/*
simple method for drawing a scaled polygon.
scale - [x,y,z] scaling vectors
move - [x,y,z] direction vectors
shape - [[x,y]] array of points defining polygon
wall - thickness of wall. only for hollow objects
hollow - 0 or 1.
*/
module draw(scale, move, shape, wall, hollow)
{
    translate(move) 
    scale(scale) 
    linear_extrude(1,center=true)
    if (hollow)
    {
        difference()
        {
            minkowski()
            {
                polygon(shape);
                circle(wall);
            }
            
            polygon(shape);
        }
    }
    else
    {
        polygon(shape);
    }
}

downSpoutPoints = [

[-39.3738,15.0053],
[-39.2166,15.9981],
[-38.9973,16.979],
[-38.7169,17.9443],
[-38.3764,18.89],
[-37.9772,19.8125],
[-37.5209,20.7081],
[-37.0092,21.5732],
[-36.4443,22.4046],
[-35.8282,23.1988],
[-35.1635,23.9527],
[-34.4527,24.6635],
[-33.6988,25.3282],
[-32.9046,25.9443],
[-32.0732,26.5092],
[-31.2081,27.0209],
[-30.3125,27.4772],
[-29.39,27.8764],
[-28.4443,28.2169],
[-27.479,28.4973],
[-26.4981,28.7166],
[-25.5053,28.8738],
[-24.5046,28.9684],
[-23.5,29],
[23.5,29],
[24.5046,28.9684],
[25.5053,28.8738],
[26.4981,28.7166],
[27.479,28.4973],
[28.4443,28.2169],
[29.39,27.8764],
[30.3125,27.4772],
[31.2081,27.0209],
[32.0732,26.5092],
[32.9046,25.9443],
[33.6988,25.3282],
[34.4527,24.6635],
[35.1635,23.9527],
[35.8282,23.1988],
[36.4443,22.4046],
[37.0092,21.5732],
[37.5209,20.7081],
[37.9772,19.8125],
[38.3764,18.89],
[39.3738,15.0053],
[39.4684,14.0046],
[39.5,13],
[39.5,-13],
[39.4684,-14.0046],
[39.3738,-15.0053],
[39.2166,-15.9981],
[38.9973,-16.979],
[38.7169,-17.9443],
[38.3764,-18.89],
[37.9772,-19.8125],
[37.5209,-20.7081],
[37.0092,-21.5732],
[36.4443,-22.4046],
[35.8282,-23.1988],
[35.1635,-23.9527],
[34.4527,-24.6635],
[33.6988,-25.3282],
[32.9046,-25.9443],
[32.0732,-26.5092],
[31.2081,-27.0209],
[30.3125,-27.4772],
[29.39,-27.8764],
[28.4443,-28.2169],
[27.479,-28.4973],
[26.4981,-28.7166],
[25.5053,-28.8738],
[24.5046,-28.9684],
[23.5,-29],
[-23.5,-29],
[-24.5046,-28.9684],
[-25.5053,-28.8738],
[-26.4981,-28.7166],
[-27.479,-28.4973],
[-28.4443,-28.2169],
[-29.39,-27.8764],
[-30.3125,-27.4772],
[-31.2081,-27.0209],
[-32.0732,-26.5092],
[-32.9046,-25.9443],
[-33.6988,-25.3282],
[-34.4527,-24.6635],
[-35.1635,-23.9527],
[-35.8282,-23.1988],
[-36.4443,-22.4046],
[-37.0092,-21.5732],
[-37.5209,-20.7081],
[-37.9772,-19.8125],
[-38.3764,-18.89],
[-38.7169,-17.9443],
[-38.9973,-16.979],
[-39.2166,-15.9981],
[-39.3738,-15.0053],
[-39.4684,-14.0046],
];
