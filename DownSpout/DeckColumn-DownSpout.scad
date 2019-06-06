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
FEMALE_HEIGHT = 43-FEMALE_RADIUS; //orginal value = 42.2;
FEMALE_WIDTH = 65-FEMALE_RADIUS; //orginal value = 64.2;
FEMALE_WIDTH_ACTUAL = FEMALE_WIDTH + 2*FEMALE_RADIUS;
FEMALE_HEIGHT_ACTUAL = FEMALE_HEIGHT + 2*FEMALE_RADIUS;
DS_WALL = 3;
POST_WALL = 5;
TUBE_LENGTH = 50;
CONNECTOR_LENGTH = 60;
FEMALE_DEMS = [FEMALE_WIDTH,FEMALE_HEIGHT];
MALE_RADIUS = 18;
MALE_HEIGHT = FEMALE_HEIGHT-(DS_WALL);
MALE_WIDTH = FEMALE_WIDTH-(DS_WALL+1.5);
MALE_DEMS = [MALE_WIDTH,MALE_HEIGHT];
WOOD_NOMINAL_SIZE_4IN = 89;
DECK_WOOD_POST_TOP_WIDTH = 115 + POST_WALL;
DECK_WOOD_POST_BASE_WIDTH = 126 + POST_WALL;

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
BUILD_DOUBLE_CHANNEL_CONNECTOR = 1;
INCLUDE_SHOW_POST = 1;

/*****************************************************************************
MAIN SUB - where the instructions start.
*****************************************************************************/
build();

/*****************************************************************************
MODULES: - the meat of the project.
*****************************************************************************/
module build()
{
    if(BUILD_DOUBLE_CHANNEL_CONNECTOR) doubleChannelConnector();
    else doubleChannel();

}

module doubleChannelConnector()
{
    difference()
    {
        union()
        {
            translate([0,0,-1.5])
            rotate([1,0,0])
            doubleChannel();
            // hollowCube( DECK_WOOD_POST_BASE_WIDTH,  DECK_WOOD_POST_BASE_WIDTH, FEMALE_HEIGHT_ACTUAL, POST_WALL, true);
            // resize([0,DECK_WOOD_POST_BASE_WIDTH + POST_WALL, 0],auto = [false, true, false])
            trapazoid(
                w1=DECK_WOOD_POST_TOP_WIDTH + 2*POST_WALL,
                d1 = DECK_WOOD_POST_TOP_WIDTH + 2*POST_WALL,
                w2=DECK_WOOD_POST_BASE_WIDTH + 2*POST_WALL,
                height=FEMALE_HEIGHT_ACTUAL,
                center=true );
        }
        //cut-through for post.
        // hollowCubeCore(DECK_WOOD_POST_BASE_WIDTH,  DECK_WOOD_POST_BASE_WIDTH, FEMALE_HEIGHT_ACTUAL, POST_WALL, true);
        //  resize([0,DECK_WOOD_POST_BASE_WIDTH + 2, 0],auto = [false, true, false])
        trapazoidCore(
            w1=DECK_WOOD_POST_TOP_WIDTH + 2*POST_WALL,
            d1 = DECK_WOOD_POST_TOP_WIDTH + 2*POST_WALL,
            w2=DECK_WOOD_POST_BASE_WIDTH + 2*POST_WALL,
            height=FEMALE_HEIGHT_ACTUAL,
            wall = POST_WALL,
            center=true );

        //only half
        //translate([0, half(3*CONNECTOR_LENGTH)/2, 0])
        rotate([0,0,90])
        linear_extrude(height = FEMALE_HEIGHT_ACTUAL)
        square(size=[2 * FEMALE_WIDTH_ACTUAL, POST_WALL], center=true);
    }
}

module doubleChannel()
{
    translate([-FEMALE_WIDTH_ACTUAL/2,FEMALE_WIDTH_ACTUAL,half(FEMALE_HEIGHT_ACTUAL)])
    rotate([90,0,0])
    difference()
    {
        union()
        {
            translate([FEMALE_WIDTH_ACTUAL+DS_WALL,0,0])
            //downSpout(dimensions, radius, wall,           length,     rightside = -1, ratio = 0)
            downSpout(FEMALE_DEMS, FEMALE_RADIUS, DS_WALL, 3*CONNECTOR_LENGTH,1);
            translate([-DS_WALL,0,0])
            downSpout(FEMALE_DEMS, FEMALE_RADIUS, DS_WALL, 3*CONNECTOR_LENGTH);
        }
    }
}

module hollowCube(width, depth, height, wall, center) 
{
    linear_extrude(height = height, scale=[1,1/2], twist = 0)
    difference()
    {
        square(size=[width,depth], center = center);
        // translate([half(wall),half(wall),0])
        square(size=[width-wall,depth-wall], center = center);
    }    
}
module hollowCubeCore(width, depth, height, wall, center) 
{
    linear_extrude(height = height, scale=[1,1/2], twist = 0)
    square(size=[width-wall,depth-wall], center = center);
}

module hollowTrapazoid(w1, d1, w2,  height,  wall, center)
{
    difference()
    {
        trapazoid(w1, d1, w2,  height,  center);
        trapazoidCore(w1, d1, w2,  height,  wall, center);
    }
}

module trapazoid(w1, d1, w2,  height,  center)
{
    union()
    {
        echo(w1/w2);
        linear_extrude(height = height, scale = w1/w2)
        square([w1,d1], center = center);
    }
}

module trapazoidCore(w1, d1, w2,  height, wall, center)
{
    trapazoid(w1-wall, d1-wall, w2-wall,height, center);
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

module downSpout(dimensions, radius, wall, length,rightside = -1)
{
    echo(ratio = MALE_WIDTH/FEMALE_WIDTH);
    linear_extrude(height = length, scale = MALE_WIDTH/FEMALE_WIDTH )
    {
        difference()
        {
            offset(r = radius) square(dimensions,center = true);
            union()
            {
                offset(r = radius-wall) square(dimensions,center = true);
                if(INCLUDE_CHANNEL)
                {
                    offset = 8;
                    translate([rightside*offset,20,0])
                    square([dimensions[0]+2*wall+2+ 1.5*offset,dimensions[0]],center = true);
                }
            }
        }
    }
}
