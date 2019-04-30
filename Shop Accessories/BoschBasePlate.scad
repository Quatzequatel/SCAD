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
TWOBYFOUR_WIDTH = 90;

WORKBENCH_PLATE_LENGTH = 200;

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
INCLUDE_2X4_GUIDE = 0;
INCLUDE_2X4_GUIDE_BRACES = 0;
INCLUDE_WORKBENCH_PLATE = 1;
BUILD_WORKBENCH_FENCE = 1;
/*****************************************************************************/
//Directives - end
/*****************************************************************************/
 
/*****************************************************************************/
// MAIN SUB
/*****************************************************************************/
// if (BUILD_WORKBENCH_FENCE) 
// {
//     workbench_fence_rail();    
// }
// else
build();

/*****************************************************************************/
// modules
/*****************************************************************************/
module build()
{
        difference()
        {
            union()
            {
                cylinder(h = BASE_THICKNESS, d = OUTER_DIAMETER);
                if(INCLUDE_2X4_GUIDE) two_by_four_template();
                if(INCLUDE_WORKBENCH_PLATE) 
                {
                    workbench_plate();
                    workbench_fence_rail();
                }
            }           
            
            union()
            {
                mounting_holes();
                cylinder(h = BASE_THICKNESS, d = INNER_DIAMETER);
                if(INCLUDE_HEX_HOLE) hexHole();
                if(INCLUDE_COUNTER_SINK) countersunk();  
                if(INCLUDE_WORKBENCH_PLATE)
                {
                    workbench_groove(1);
                    workbench_groove(-1);
                } 
            }
        }     
}

module workbench_plate()
{
    difference()
    {
        linear_extrude(height=BASE_THICKNESS) 
        square(size=[WORKBENCH_PLATE_LENGTH, WORKBENCH_PLATE_LENGTH], center=true);

        linear_extrude(height=BASE_THICKNESS/2)
        difference()
        {
            square(size=[WORKBENCH_PLATE_LENGTH, WORKBENCH_PLATE_LENGTH], center=true);
            square(size=[WORKBENCH_PLATE_LENGTH-10, WORKBENCH_PLATE_LENGTH-10], center=true);
        }

    }
}

module workbench_fence_rail() 
{
    translate([165, 0, 0]) 

    difference()
    {
        union()
        {
            translate([0, 0, WORKBENCH_PLATE_LENGTH/8]) 
            {
                rotate([0, 90, 0]) 
                {    
                    linear_extrude(height=BASE_THICKNESS)
                    square(size=[50, WORKBENCH_PLATE_LENGTH], center=true);
                }
            }

            translate([-(WORKBENCH_PLATE_LENGTH/8), 0, 0]) 
            linear_extrude(height=BASE_THICKNESS)
            square(size=[50, WORKBENCH_PLATE_LENGTH], center=true);

            //braces
            translate([0,-35,BASE_THICKNESS])
            twobyfour_guide_braces(1);

            translate([0,40,BASE_THICKNESS])
            twobyfour_guide_braces(1);
        }
        translate([0, 0, -13]) 
        cylinder(h = 50, d = INNER_DIAMETER);

        mounting_holes(1,2);
        countersunk(1,2);

    }
}

module workbench_groove(top = 1)
{
    translate([-10, top * 50, 0]) 
    linear_extrude(height=2*BASE_THICKNESS) 
    hull() 
    {
        translate([100, 0, 0]) 
        {
            circle(d=HOLE_DIAMETER);        
        }
        circle(d=HOLE_DIAMETER);
    }
}

module hole()
{
  cylinder(h= BASE_THICKNESS + 2, d = HOLE_DIAMETER);
}

// 3 holes at intervals of 120 degree angles.
module mounting_holes(min = 0, max = 2)
{
    for(i=[min:max])
    {
        translate(translatePointsForAngle(0,HOLE_DISTANCE,ANGLES[i])) hole();
    }
}

module countersunk(min = 0, max = 2) {
  for(i=[min:max])
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
        rotate([0,0,-8]) twobyfour_guide();
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

    if(INCLUDE_2X4_GUIDE_BRACES)
    {
        translate([half(TWOBYFOUR_WIDTH)-2,-20,BASE_THICKNESS])
        twobyfour_guide_braces(-1);

        translate([half(TWOBYFOUR_WIDTH)-2,15,BASE_THICKNESS])
        twobyfour_guide_braces(-1);

        translate([-half(TWOBYFOUR_WIDTH)-BASE_THICKNESS+1,30,BASE_THICKNESS])
        twobyfour_guide_braces();

        translate([-half(TWOBYFOUR_WIDTH)-BASE_THICKNESS+1,-20,BASE_THICKNESS])
        twobyfour_guide_braces();
    }
}

module twobyfour_guide_braces(left = 1)
{
    triangle = [[0,0],[0,1],[1,0]];
    rotate([90*left,-90,0])
    if (left == 1) 
    {
        scale([38,18,BASE_THICKNESS]) 
        linear_extrude(height =1) 
        polygon(triangle);
    }
    else 
    {
        scale([38,30,BASE_THICKNESS]) 
        linear_extrude(height =1) 
        polygon(triangle);
    }
}