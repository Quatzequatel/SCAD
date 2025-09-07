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
TIGHT_ELBOW_90_OFFSET = 40;
ELBOW_ANGLE = 90;
FEMALE_RADIUS = 21;
FEMALE_HEIGHT = 43-FEMALE_RADIUS; //orginal value = 42.2;
FEMALE_WIDTH = 65-FEMALE_RADIUS; //orginal value = 64.2;
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
function swap(arr) = [arr[1],arr[0]];
function actualWidth(length, radius, wall) = TIGHT_ELBOW_90_OFFSET;

/*****************************************************************************
Directives - defines what to build with optional features.
*****************************************************************************/
INCLUDE_CHANNEL = 0;
BUILD_MALE_CONNECTOR = 0;
BUILD_ELBOW_CONNECTOR = 0;
BUILD_STRAIGHT_CONNECTOR = 0;
BUILD_T_TUBE = 0;
BUILD_L_TUBE = 1;
BUILD_ENDSTOP_ELBOW = 0;
BUILD_ROUNDPIPE_STRAIGHT_CONNECTOR = 0;
BUILD_NORMAL_DOWNSPOUT_ELBOW = 0;
BUILD_TRIPLE_ELBOW_CONNECTOR = 0;
BUILD_OFFSET_ELBOW_CONNECTOR = 0;
BUILD_LARGE_SINGLE_ELBOW_CONNECTOR = 0;


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
    if(BUILD_TRIPLE_ELBOW_CONNECTOR) triple_elbow_connector();
    if(BUILD_MALE_CONNECTOR) maleConnector();
    if(BUILD_STRAIGHT_CONNECTOR) straightConnector();
    if(BUILD_T_TUBE) ttubeConnector();
    if(BUILD_L_TUBE) L_TubeConnector();
    if(BUILD_ENDSTOP_ELBOW) endstop_elbow();
    if(BUILD_ROUNDPIPE_STRAIGHT_CONNECTOR)
    {
        connector_straight_roundpipe(65,62,20,3);
    }
    if(BUILD_NORMAL_DOWNSPOUT_ELBOW)normal_downspout_elbow();
    if(BUILD_OFFSET_ELBOW_CONNECTOR) OFFSET_ELBOW_CONNECTOR();
    if(BUILD_LARGE_SINGLE_ELBOW_CONNECTOR) large_single_elbow_connector();
}

module OFFSET_ELBOW_CONNECTOR()
{
    BOX_WIDTH = 115; //FEMALE_WIDTH + 20 + 2*FEMALE_RADIUS;

    difference()
    {
        union()
        {
            //MAIN CHAMBER
            color("SteelBlue")translate([40,22 + FEMALE_RADIUS,0])
            rotate([0,0,90])
            downSpout(dimensions=[BOX_WIDTH, FEMALE_HEIGHT], radius=FEMALE_RADIUS, wall=DS_WALL, length=60);
            //main Chamber floor
            color("LightSteelBlue")translate([40,22 + FEMALE_RADIUS,0])
            rotate([0,0,90])
            downSpout_Center(dimensions=[BOX_WIDTH,FEMALE_HEIGHT], radius=FEMALE_RADIUS, wall=DS_WALL, length=3*DS_WALL);

            //main Chamber ceiling
            color("SkyBlue")translate([40,22 + FEMALE_RADIUS,60-DS_WALL])
            rotate([0,0,90])
            downSpout_Center(dimensions=[BOX_WIDTH ,FEMALE_HEIGHT], radius=FEMALE_RADIUS, wall=DS_WALL, length=DS_WALL);

            //input Connector (female)
            color("Aquamarine")
            translate([40,15,60])
            rotate([0,0,90])
            downSpout(dimensions=FEMALE_DEMS, radius=FEMALE_RADIUS, wall=DS_WALL, length=30);

            //exit Connector (male)
            color("Aqua")
            translate([-30,MALE_WIDTH*2+5,MALE_HEIGHT+MALE_RADIUS-DS_WALL])
            rotate([90,0,90])
            downSpout(dimensions=MALE_DEMS, radius=MALE_RADIUS, wall=DS_WALL, length=50);
        }
        //input hole
        translate([40,15,55])
        rotate([0,0,90])
        downSpout_Center(dimensions=FEMALE_DEMS , radius=FEMALE_RADIUS, wall=DS_WALL, length=30);

        //Exit hole
        translate([-15,MALE_WIDTH*2+5,MALE_HEIGHT+MALE_RADIUS-DS_WALL])
        rotate([90,0,90])
        downSpout_Center(dimensions=MALE_DEMS, radius=MALE_RADIUS, wall=DS_WALL, length=50);
    }

}

module connector_straight_roundpipe(outerDiameter, innerDiameter, length,wall) {
    
    //connector
    translate([0,0,-length/2])
    difference()
    {
        linear_extrude(height=length, center=true, convexity=10, twist=0) 
        {
            difference()
            {
                circle(d=outerDiameter);
                circle(d=innerDiameter);
            }
        }

        translate([0, half(outerDiameter)-8, -half(outerDiameter)]) 
        rotate([0,90,90])
        cylinder(d=outerDiameter,h=20,center=true);
    }


    //bevel
    color("Turquoise")
    translate([0,0, half(length/3)])
    difference()
    {
        cylinder(d1=outerDiameter, d2=innerDiameter, h=length/3, center=true);
        cylinder(d1=outerDiameter-wall, d2=innerDiameter-2*wall, h=length/3, center=true);
    }

    translate([0,0,11])
    color("PaleTurquoise")
    linear_extrude(height=length/2, center=true, convexity=10, twist=0) 
    {
        difference()
        {
            circle(d=outerDiameter-wall);
            circle(d=innerDiameter-2*wall);
        }
    }
}


module endstop_elbow() 
{
    difference()
    {
        normal_downspout_elbow
    ();
    
        color("PaleTurquoise")
        translate([0,0,-half(TIGHT_ELBOW_90_OFFSET)])
        rotate([0,0,90])
        linear_extrude(height=CONNECTOR_LENGTH+TIGHT_ELBOW_90_OFFSET)
        offset(r = FEMALE_RADIUS-DS_WALL) square(15,center = true);
    }
}

module triple_elbow_connector() 
{
    difference()
    {
        union()
        {
            translate([-100,60,0])
            rotate([90,0,90])
            downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, 200);

            translate([100,0,0])
            elbowConnector();
            elbowConnector();
            translate([-100,0,0])
            elbowConnector();
        }
            translate([50,0,0])
            rotate([0,0,90])
            #channel2(250);
            
            translate([-100,60,0])
            rotate([90,0,90])
            downSpout_Center(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, 200);
            
            translate([100,0,0])
            elbow_center();
            elbow_center();
            translate([-100,0,0])
            elbow_center();
    }
}

/*
    simple elbow with long straight section on one side.
    modification of triple elbow connector.
*/
module large_single_elbow_connector() 
{
    difference()
    {
        union()
        {
            //Long tube section.
            translate([-100,60,0])
            rotate([90,0,90])
            downSpout(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, 200);

            translate([100,0,0])
            elbowConnector();
            //elbowConnector();
            //translate([-100,0,0])
            //elbowConnector();
        }
            //Open channel for water to flow.
            translate([50,0,0])
            rotate([0,0,90])
            channel2(250);
            
            translate([-100,60,0])
            rotate([90,0,90])
            downSpout_Center(FEMALE_DEMS,FEMALE_RADIUS,DS_WALL, 200);
            
            translate([100,0,0])
            elbow_center();
            // elbow_center();
            // translate([-100,0,0])
            // elbow_center();
    }
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
    //Main elbow body of the T tube.
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

    
    //Connectors for T tube channel.
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

module L_TubeConnector()
{
    //Main elbow body of the T tube.
    difference()
    {
        union()
        {
            elbow();
        }

        union()
        {
            elbowChannel();   
        }
    }

    
    //Connectors for L tube channel.
    difference()
    {
        union()
        {
            translate([ELBOW_90_OFFSET,0,0])
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

module channel2(length, channelWidth = 15, offsetRadius = FEMALE_RADIUS-DS_WALL)
{
    color("LightCyan")
    translate([60,-TUBE_LENGTH,30])
    rotate([0,90,90])
    linear_extrude(height=length)
    offset(r = offsetRadius) square(channelWidth,center = true);
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
    color("Aqua")rotate_extrude(angle=right * ELBOW_ANGLE,convexity = 10)
    translate([ELBOW_90_OFFSET, 0, 0])
    difference()
    {
        offset(r = FEMALE_RADIUS) square(FEMALE_DEMS,center = true);
        offset(r = FEMALE_RADIUS-DS_WALL) square(FEMALE_DEMS,center = true);
    }
}

module elbow_center(demension = FEMALE_DEMS, offsetRadius = FEMALE_RADIUS - DS_WALL, angle = 90 )
{
    rotate_extrude(angle=angle,convexity = 10)
    translate([ELBOW_90_OFFSET, 0, 0])
    offset(r = offsetRadius) square(demension,center = true);
}

module  normal_downspout_elbow()
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

module downSpout_Center(dimensions,radius, wall, length)
{
    linear_extrude(height = length)
    {
        offset(r = radius-wall) square(dimensions,center = true);
    }
}
