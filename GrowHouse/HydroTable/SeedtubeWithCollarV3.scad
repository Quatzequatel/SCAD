

$fn = 150;

mutipleSeedTubes(4,4);

module mutipleSeedTubes(rows, columns)
{
    CylinderWidth=50;
    CellPad=25;
    
     for(x = [1:rows], Y =[1:columns])
     {
         echo([(CylinderWidth*(x-1))+CellPad, (CylinderWidth*(Y-1))+CellPad,0]);
         translate([(CylinderWidth*(x-1))+CellPad, (CylinderWidth*(Y-1))+CellPad,0])  
         SeedTube();
     }
}

module SeedTube()
{
    CylinderWidth=40;
    CylinderHeight=50;
    wallWidth=2; 
    
    LipRadiusOuter=23;
    LipRadiusInner=18;
    LipHeight=2;    

union()
    {
    tube(CylinderWidth/2,wallWidth, CylinderHeight);        
    Lip(LipRadiusOuter, LipRadiusOuter-LipRadiusInner, LipHeight);
    doughnut();
    }
}

module tube(outerDiameter, wallThickness, height)
{
    linear_extrude(height,true)
    difference()
    {
        circle(outerDiameter,true);
        circle(outerDiameter-wallThickness,true);
    }
}

module doughnut()
{
    translate([0, 0, 31.3])
    #rotate_extrude(angle=360, convexity = 10)
    translate([17, 17,0])
    circle(r = 2);
}

module Lip(outerDiameter, wallThickness, height)
{
    color("Green")
     tube(outerDiameter, wallThickness, height);
}    