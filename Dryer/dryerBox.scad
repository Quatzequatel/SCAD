$fn = 100;

OD = 101; //4.0 inch
InsideWidth = 241; //9.5 inch
OutsideDepth = 120; //5 inch
OutsideLength = 355; //14 inch
MoldingWidth = 18s; //1 inch
grMoldingWidth = 11.12461;
grMoldingRadius = 6.87539;

//difference()
//{
//    cube ([OutsideLength,InsideWidth,OutsideDepth]);
//    translate([OutsideLength+1,-1,InsideWidth])
//    rotate([0,90,90])
//    linear_extrude(height = InsideWidth+2)
//    polygon(points=[[0,0],[InsideWidth,0],[0,InsideWidth]],convexity=1);
//    
//    #translate([-1,(InsideWidth/2),OutsideDepth/2])
//    rotate([0,90,0])
//    cylinder(h=100, d1=OD, d2 = OD);
//}

module dryerBox(length, width, height, wall)
{
    difference()
    {
        componentbox(length, width, height);
        translate([wall/2,wall/2,-wall/2])
        componentbox(length-wall, width-wall, height-wall);
        translate([-1,(InsideWidth/2),OutsideDepth/2])
        rotate([0,90,0])
        cylinder(h=240, d1=OD, d2 = OD);
    }
    
}

module componentbox(length, width, height)
{
    difference()
    {
    cube([length, width, height]);
    
    translate([length+1,-1,width])
    rotate([0,90,90])
    linear_extrude(height = width+2)
    polygon(points=[[0,0],[width,0],[0,width]],convexity=1);
    }
}

difference()
{
dryerBoxMolding(OutsideLength,InsideWidth,5,MoldingWidth,1.7);

rotate([180,0,0])
dryerBox(OutsideLength,InsideWidth,OutsideDepth,5);
    dryerBoxMoldingCut(OutsideLength,InsideWidth,5);
    

    
}

module dryerBoxMoldingCut(boxLength, boxWidth, wall)
{
        translate([2.5,-(boxWidth-2.6),-4])
    cube([boxLength-(wall)-1.7, boxWidth+(wall)-10, wall]);
}

module dryerBoxMolding(boxLength, boxWidth, wall, moldingWidth, moldingThickness)
{
    translate([-grMoldingWidth, -(boxWidth + grMoldingWidth),-2])
    minkowski()
    {
        cube([boxLength + 2*grMoldingWidth, boxWidth + 2*grMoldingWidth, moldingThickness]);
        cylinder(r=grMoldingRadius,h=1);
    }
}

//function adjustedMoldingWidth(w) = w*0.666