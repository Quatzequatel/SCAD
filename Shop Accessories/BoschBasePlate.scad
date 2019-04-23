/*****************************************************************************/
// CONSTANTS - BEGIN
/*****************************************************************************/
HOLE_DISTANCE = 58;
//angles for mounting holes
ANGLES = [0,120,240];

$fn=100;

// Diameter of Mounting Holes in Router Base
HOLE_DIAMETER = 5.6;
HEX_HOLE_DIAMETER = 8;
HEX_HOLE_DISTANCE = 65.25;

TWOBYFOUR = [38,89]; //Finished 2x4 is 38mm x 89mm
TWOBYFOUR_HEIGHT = 38;
TWOBYFOUR_WIDTH = 89;

// Router Base Thickness (for complex_circle, ensure this is more than thickness of inlay)
BASE_THICKNESS = 8; 

// Outer Diameter of Router Base
OUTER_DIAMETER = 153.5;
// Diameter of Router Base Cutout
INNER_DIAMETER = 52.5;

PI = 4 * atan2(1,1); 

/*****************************************************************************/
// CONSTANTS - END
/*****************************************************************************/
// FUNCTIONS:
// the following set of functions work together to return the x,y coordinate
// from an existing point and angle. see https://en.wikipedia.org/wiki/Atan2 for
// more information.
/*****************************************************************************/
//returns [x,y,z] array for consumption directly into translate(). z is arbitrarily set to 0.
function translatePointsForAngle(x,y,angle)= [pointForX(x,y,angle),pointForY(x,y,angle),0];
//returns distance from [0,0].
function radius(x,y) = sqrt(x*x + y*y);
function theta(x,y,angle) = atan2(y,x)-angle * PI / 180;
function pointForX(x,y,angle) = radius(x,y) * sin(theta(x,y,angle));
function pointForY(x,y,angle) = radius(x,y) * cos(theta(x,y,angle));
//simplify for readability
function half(x) = x/2;

/*****************************************************************************/
//Directives - start
/*****************************************************************************/
INCLUDE_HEX_HOLE = 0;
INCLUDE_COUNTER_SINK = 1;
INCLUDE_2X4_GUIDE = 1;
/*****************************************************************************/
//Directives - end
/*****************************************************************************/
 
/*****************************************************************************/
// MAIN SUB
/*****************************************************************************/
base_plate();

/*****************************************************************************/
// modules
/*****************************************************************************/
module hole()
{
  cylinder(h= BASE_THICKNESS + 2, d = HOLE_DIAMETER);
}

// 3 holes at intervals of 120 degree angles.
module mounting_holes()
{
    for(i=[0:2])
    {
        translate(translatePointsForAngle(0,HOLE_DISTANCE,ANGLES[i])) hole();
    }
}

module countersunk() {
  for(i=[0:2])
  {
      translate(translatePointsForAngle(0,HOLE_DISTANCE,ANGLES[i]))   cylinder(r2=(HOLE_DIAMETER/2) + BASE_THICKNESS/2, r1=(HOLE_DIAMETER/2), h=BASE_THICKNESS + 1);
  }
}

module hexHole()
{
    translate(translatePointsForAngle(0,HEX_HOLE_DISTANCE,180)) cylinder(h = BASE_THICKNESS, d = HEX_HOLE_DIAMETER);
}

module two_by_four_template()
{
    difference()
    {
        twobyfour_guide();
        translate([0,0,-1])
        cylinder(h = TWOBYFOUR_WIDTH +BASE_THICKNESS, d = INNER_DIAMETER);
    }
}

module twobyfour_guide()
{
    translate([TWOBYFOUR_WIDTH/2,OUTER_DIAMETER/2,0])
    rotate([90,-90,0])
    linear_extrude(height=OUTER_DIAMETER) 
    difference()
    {
        square([TWOBYFOUR_HEIGHT + BASE_THICKNESS,TWOBYFOUR_WIDTH + BASE_THICKNESS]);
        translate([half(BASE_THICKNESS),half(BASE_THICKNESS),0])
        square([TWOBYFOUR_HEIGHT + BASE_THICKNESS,TWOBYFOUR_WIDTH]);
    }
}

module base_plate()
{
        difference()
        {
            union()
            {
                cylinder(h = BASE_THICKNESS, d = OUTER_DIAMETER);
                if(INCLUDE_2X4_GUIDE) two_by_four_template();
            }           
            
            union()
            {
                mounting_holes();
                cylinder(h = BASE_THICKNESS, d = INNER_DIAMETER);
                if(INCLUDE_HEX_HOLE) hexHole();
                if(INCLUDE_COUNTER_SINK) countersunk();  
            }
        }     
}