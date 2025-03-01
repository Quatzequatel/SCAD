outerwidth1 = 78;
outerheight1 = 58;
height1 = 110;
wallThickness1 = 8;

outerwidth2 = 73;
outerheight2 = 53;
height2 = 100;
wallThickness2 = 8;

minkowski_circle = 16;


squareTube(outerwidth2,outerheight2,wallThickness2,10);

module squareTube(outerwidth, outerheight, wallThickness, height)
{
        //linear_extrude(height,true)
    difference()
    {
        linear_extrude(height,true)
        minkowski()
        {
        square([outerwidth-minkowski_circle, outerheight-minkowski_circle],true);
            circle(minkowski_circle);
        }
        translate([0,0,-2],true)
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