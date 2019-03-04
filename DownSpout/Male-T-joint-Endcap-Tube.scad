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
lip = 4;
outerWidthDownspout= 80.5 - minkowski_circle;
outerheightDownspout = 58 - minkowski_circle;

//endCapDownSpout();
//L_Tube(outerwidth2,outerheight2,wallThickness2,height);

endStop(outerWidthDownspout,outerheightDownspout,wallThickness2,lip);


module endCapDownSpout()
{
    rotate([0,270,0]) 
    endCap(outerWidthDownspout,outerheightDownspout,wallThickness2,lip);
}

module endCap(outerwidth2,outerheight2,wallThickness2,thickness)
{
    difference()
    {
        translate([-thickness,0,0])
        endStop(outerwidth2+thickness,outerheight2+thickness,wallThickness2, thickness*3);
        endStop(outerwidth2,outerheight2,wallThickness2,thickness*2);
    }
}

module endStop(outerwidth2,outerheight2,wallThickness2,thickness)
{
    //translate([-height/2,0,0])
    //rotate([0,0,90]) 
    rotate([90,0,90]) 
    solidTube(outerwidth2,outerheight2,wallThickness2,thickness); 
}

module T_Tube(outerwidth2,outerheight2,wallThickness2,height)
{
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
}

module L_Tube(outerwidth2,outerheight2,wallThickness2,height)
{
    difference()
    {
        thisHeight = height/2;
        thisOffset = 22;

        union()
        {
            translate([-thisHeight,0,0])
            rotate([90,0,90]) 
            solidTube(outerwidth2,outerheight2,wallThickness2,thisHeight+thisOffset);
           
            translate([0,thisHeight,0])
            rotate([90,0,0]) 
            solidTube(outerwidth2,outerheight2,wallThickness2,thisHeight+thisOffset); 
        }
    
        union()
        {
            translate([-thisHeight-2,0,0])
            rotate([90,0,90]) 
            solidTube(outerwidth2-wallThickness,outerheight2-wallThickness,wallThickness,thisHeight+thisOffset+4);
           
            translate([0,height/2+2,0])
            rotate([90,0,0]) 
            solidTube(outerwidth2-wallThickness,outerheight2-wallThickness,wallThickness,thisHeight+thisOffset+4); 
        }
        
        translate([0,0,thisHeight+28])
        cube(height + 4, center = true);
        
    }
}


module squareTube(outerwidth, outerheight, wallThickness, height)
{
    linear_extrude(height,true)
    difference()
    {
        minkowski()
        {
        square([outerwidth-minkowski_circle, outerheight-minkowski_circle],true);
            circle(minkowski_circle);
        }
        
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