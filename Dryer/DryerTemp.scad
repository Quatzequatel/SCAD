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