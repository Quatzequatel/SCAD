/*
Description : 
    Creates clamp-bands for inside open downspout.
    These hold things like rubber or screens.
*/

/*****************************************************************************
CONSTANTS
*****************************************************************************/
//$fs = 0.01;
//$fa = 0.01;
$fn = 100;
minkowski_circle = 16;
wallThickness = 4;

outerwidth1 = 78;
outerheight1 = 58;
height1 = 110;
wallThickness1 = wallThickness;

outerwidth2 = 76 - minkowski_circle;
outerheight2 = 56 - minkowski_circle;
height2 = 100;
wallThickness2 = wallThickness;



squareTube(outerwidth2,outerheight2,wallThickness2,10);

module squareTube(outerwidth, outerheight, wallThickness, height)
{
    difference()
    {
        echo(width = outerwidth-minkowski_circle, height = outerheight-minkowski_circle);
        linear_extrude(height,true)
        minkowski()
        {
        square([outerwidth-minkowski_circle, outerheight-minkowski_circle],true);
            circle(minkowski_circle);
        }
        
        translate([0,0,-2])
        linear_extrude(height+4,true)
        minkowski()
        {
        square([outerwidth-wallThickness-minkowski_circle,outerheight-wallThickness-minkowski_circle],true);
                        circle(minkowski_circle);
        }
    }
}

module solidTube(outerwidth, outerheight, wallThickness, height)
{
    linear_extrude(height,true)
    minkowski()
    {
        square([outerwidth-minkowski_circle, outerheight-minkowski_circle],true);
        circle(minkowski_circle);
    }
}