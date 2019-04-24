/*
Discription: creates a coupling, to connect 2 4" flex dryer vent ducts together.
Increased wall thickness to 4 for stronger wall. 
Moved catch brim up half(COUPLING_WALL)
*/

/*****************************************************************************/
// CONSTANTS 
/*****************************************************************************/
$fn=100;
// Diameter of Mounting Holes in Router Base
COUPLING_ABSOLUTE_MAX = 101.6; //This is 4" diameter.
COUPLING_DIAMETER = 99;
COUPLING_HEIGHT = 50;
COUPLING_WALL=4;

PI = 4 * atan2(1,1); 
/*****************************************************************************/
// FUNCTIONS:

/*****************************************************************************/
function half(x) = x/2;
function tapperThickness() = COUPLING_ABSOLUTE_MAX + 1.4;
function externalDiameter() = tapperThickness() + 3;

/*****************************************************************************/
//Directives
/*****************************************************************************/
 
/*****************************************************************************/
// MAIN SUB
/*****************************************************************************/

// internalStriaghtCoupler();
// externalHalfCoupler();
StraightDirectionalFlowCoupler();

/*****************************************************************************/
// modules
/*****************************************************************************/
module internalStriaghtCoupler()
{
    //bottom half of coupling
    #translate([0,0,-half(COUPLING_HEIGHT)])
    // rotate([0,0,0])
    internalHalfCoupler(1);

    //top half of coupling
    translate([0,0,half(COUPLING_HEIGHT)])
    rotate([0,0,90])
    internalHalfCoupler(0);

    //catch brim top part
    translate([0,0,(COUPLING_HEIGHT-half(COUPLING_WALL))])
    rotate_extrude(angle = 360,convexity = 10)
    translate([half(COUPLING_DIAMETER),0,0])
    circle(d=half(COUPLING_WALL));

    //catch brim bottom part
    translate([0,0,-(COUPLING_HEIGHT-half(COUPLING_WALL))])
    rotate_extrude(angle = 360,convexity = 10)
    translate([half(COUPLING_DIAMETER),0,0])
    circle(d=half(COUPLING_WALL));
}

module StraightDirectionalFlowCoupler()
{
        //bottom half of coupling
    #translate([0,0,half(COUPLING_HEIGHT)])
    // rotate([0,0,0])
    internalHalfCoupler(0);

    //top half of coupling
    translate([0,0,-half(COUPLING_HEIGHT)])
    rotate([0,0,90])
    externalHalfCoupler(0);

    //catch brim output side
    translate([0,0,(COUPLING_HEIGHT-half(COUPLING_WALL))])
    rotate_extrude(angle = 360,convexity = 10)
    translate([half(COUPLING_DIAMETER),0,0])
    circle(d=half(COUPLING_WALL));
}

module internalHalfCoupler(top = 1)
{
    difference()
    {
        // if(!top) cylinder(d1=externalDiameter(), d2=COUPLING_DIAMETER, h=COUPLING_HEIGHT, center=true);
        if(!top) TappeeredTube(xd1 = externalDiameter(), 
                                xd2 = COUPLING_DIAMETER,
                                id1= externalDiameter()-COUPLING_WALL,
                                id2=COUPLING_DIAMETER-COUPLING_WALL, 
                                h = COUPLING_HEIGHT,
                                center = true);
        if(top) cylinder(d1=COUPLING_DIAMETER, d2=externalDiameter(), h=COUPLING_HEIGHT, center=true);
    }
}

module externalHalfCoupler(top = 1)
{
    echo(top);
    difference()
    {
        cylinder(d=externalDiameter(), h=COUPLING_HEIGHT, center=true);

        if(!top) cylinder(d1=externalDiameter(), d2=COUPLING_DIAMETER, h=COUPLING_HEIGHT+1, center=true);
        if(top) cylinder(d1=COUPLING_DIAMETER, d2=externalDiameter(), h=COUPLING_HEIGHT+1, center=true);
    }
}

//d1= bottom of cone
//d2= top of cone
module TappeeredTube(xd1,xd2,id1,id2,h,center = true)
{
    echo(xd1,xd2,id1,id2,h,center);
    difference()
    {
        cylinder(d1 = xd1, d2 = xd2, h=h, center=true);

        translate([0,0,-1])
        cylinder(d1 = id1, d2 = id2, h=h+2, center=true);
    }
}