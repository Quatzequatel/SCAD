/*
Discription: creates a coupling, to connect 2 4" flex dryer vent ducts together.
*/

/*****************************************************************************/
// CONSTANTS 
/*****************************************************************************/
$fn=100;

// Diameter of Mounting Holes in Router Base
COUPLING_ABSOLUTE_MAX = 101.6; //This is 4" diameter.
COUPLING_DIAMETER = 100;
COUPLING_HEIGHT = 50;
COUPLING_WALL=2;

PI = 4 * atan2(1,1); 
/*****************************************************************************/
// FUNCTIONS:

/*****************************************************************************/

function half(x) = x/2;
function tapperThickness(diameter,wall) = diameter + wall * 4;

/*****************************************************************************/
//Directives
/*****************************************************************************/


 
/*****************************************************************************/
// MAIN SUB
/*****************************************************************************/

build();

/*****************************************************************************/
// modules
/*****************************************************************************/
module build()
{
    //bottom half of coupling
    translate([0,0,-half(COUPLING_HEIGHT)])
    difference()
    {
        cylinder(d1=COUPLING_DIAMETER, d2=tapperThickness(COUPLING_DIAMETER,COUPLING_WALL), h=COUPLING_HEIGHT, center=true);

        cylinder(d=COUPLING_DIAMETER-COUPLING_WALL, h=COUPLING_HEIGHT, center=true);
    }

    //top half of coupling
    translate([0,0,half(COUPLING_HEIGHT)])
    difference()
    {
        cylinder(d1=tapperThickness(COUPLING_DIAMETER,COUPLING_WALL), d2=COUPLING_DIAMETER, h=COUPLING_HEIGHT, center=true);

        cylinder(d=COUPLING_DIAMETER-COUPLING_WALL, h=COUPLING_HEIGHT, center=true);
    }

    //catch brim top part
    translate([0,0,COUPLING_HEIGHT])
    rotate_extrude(angle = 360,convexity = 10)
    translate([half(COUPLING_DIAMETER),0,0])
    circle(d=COUPLING_WALL);

    //catch brim bottom part
    translate([0,0,-COUPLING_HEIGHT])
    rotate_extrude(angle = 360,convexity = 10)
    translate([half(COUPLING_DIAMETER),0,0])
    circle(d=COUPLING_WALL);

}