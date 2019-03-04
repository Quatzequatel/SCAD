outerwidth1 = 78;
outerheight1 = 58;
height1 = 100;
wallThickness1 = 4;

outerwidth2 = 73.5;
outerheight2 = 53.5;
height2 = 100;
wallThickness2 = 4;


difference()
{
    crossTube(outerwidth1, outerheight1, wallThickness1, height1,
        outerwidth1, outerheight1, wallThickness1, height1);
    
    solidCrossTube(outerwidth2, outerheight2, wallThickness2, height1,
    outerwidth2, outerheight2, wallThickness2, height1);
    
}


module squareTube(outerwidth, outerheight, wallThickness, height)
{
        linear_extrude(height,true)
    difference()
    {
        minkowski()
        {
        square([outerwidth, outerheight],true);
            circle(5);
        }
        minkowski()
        {
        square([outerwidth-wallThickness,outerheight-wallThickness],true);
                        circle(5);
        }
    }
}

module crossTube(outerwidth1, outerheight1, wallThickness1, height1,
                outerwidth2, outerheight2, wallThickness2, height2)
{
    union()
    {
        translate([-15,0,0])
        rotate([90,0,90]) 
        squareTube(outerwidth1,outerheight1,wallThickness1,height1+30);


        translate([height1/2,height1/3,0])
        rotate([90,0,0]) 
        squareTube(outerwidth1,outerheight1,wallThickness2,height1);
    }
}

module solidTube(outerwidth, outerheight, wallThickness, height)
{
    linear_extrude(height,true)
    minkowski()
    {
        square([outerwidth, outerheight],true);
        circle(5);
    }
}

module solidCrossTube(outerwidth1, outerheight1, wallThickness1, height1,
                outerwidth2, outerheight2, wallThickness2, height2)
{
    union()
    {
    rotate([90,0,90]) 
    solidTube(outerwidth1,outerheight1,wallThickness1,height1);


    translate([height1/2,height1/3,0])
    rotate([90,0,0]) 
    solidTube(outerwidth1,outerheight1,wallThickness2,height1);
    }
}