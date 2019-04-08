//$fs = 0.01;
//$fa = 0.01;
$fn = 100;
minkowski_circle = 16;
wallThickness = 4;
height = 155;

//outerwidth1 = 78;
//outerheight1 = 58;
//height1 = 110;
//wallThickness1 = wallThickness;

outerwidth2 = 79 - minkowski_circle;
outerheight2 = 58 - minkowski_circle;
wallThickness2 = wallThickness;

difference()
{
    union()
    {
        translate([-height/2,0,0])
        rotate([90,0,90]) 
        solidTube(outerwidth2,outerheight2,wallThickness2,height);
       
        translate([0,height/2,0])
        rotate([90,0,0]) 
        solidTube(outerwidth2,outerheight2,wallThickness2,height/2); 
    }

    union()
    {
        translate([-height/2-2,0,0])
        rotate([90,0,90]) 
        solidTube(outerwidth2-wallThickness,outerheight2-wallThickness,wallThickness,height+4);
       
        translate([0,height/2+2,0])
        rotate([90,0,0]) 
        solidTube(outerwidth2-wallThickness,outerheight2-wallThickness,wallThickness,height/2+4); 
    }
    
    translate([0,0,height/2+28])
    cube(height + 4, center = true);
    
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