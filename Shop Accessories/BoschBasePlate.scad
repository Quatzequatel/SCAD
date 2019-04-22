
// CONSTANTS - BEGIN
HOLE_DISTANCE = 58;
//List of mounting holes x coordinates.
// HOLES_X = [60,-30,-30];
//List of mounting holes y coordinates.
// HOLES_Y = [0,51.962,-51.962];
//angles for mounting holes
ANGLES = [0,120,240];

$fn=100;

// Diameter of Mounting Holes in Router Base
HOLE_DIAMETER = 3;//5.6;
HEX_HOLE_DIAMETER = 8;
HEX_HOLE_DISTANCE = 65.25;

// Router Base Thickness (for complex_circle, ensure this is more than thickness of inlay)
BASE_THICKNESS = 1; 

// Outer Diameter of Router Base
OUTER_DIAMETER = 153.5;
// Diameter of Router Base Cutout
INNER_DIAMETER = 52.5;

PI = 4 * atan2(1,1); 


// CONSTANTS - END
function translatePointsForAngle(x,y,angle)= [pointForX(x,y,angle),pointForY(x,y,angle),0];

function radius(x,y) = sqrt(x*x + y*y);
function theta(x,y,angle) = atan2(y,x)-angle * PI / 180;
function pointForX(x,y,angle) = radius(x,y) * sin(theta(x,y,angle));
function pointForY(x,y,angle) = radius(x,y) * cos(theta(x,y,angle));

base_plate();

module hole()
{
  circle(d=HOLE_DIAMETER);
}

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
      translate(translatePointsForAngle(0,HOLE_DISTANCE,ANGLES[i]))   cylinder(r2=(HOLE_DIAMETER/2) + BASE_THICKNESS + 1, r1=(HOLE_DIAMETER/2), h=BASE_THICKNESS + 1);
  }
}

module hexHole()
{
    echo(translatePointsForAngle(0,HEX_HOLE_DISTANCE,180));
    translate(translatePointsForAngle(0,HEX_HOLE_DISTANCE,180)) circle(d=HEX_HOLE_DIAMETER);
}

module base_plate()
{
    difference()
    {
        linear_extrude(height=BASE_THICKNESS) 
        difference()
        {
            circle(d = OUTER_DIAMETER);
            mounting_holes();
            circle(d = INNER_DIAMETER);
            hexHole();
        }
        
        
    }
    
}