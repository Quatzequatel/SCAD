
meshX=26;
meshY=18;
meshZ=40;
CylinderWidth=40;
Seedrows=3;
Seedcolumns=3;
Thickness=2;
CylinderHeight=4;
CellSpacing=2;
CellPad=20;

SphereDiameter= 35;

Diameter1=27.16;
Diameter2=25.71;

Width = 18.50;
Length = Width;
Height = Width;
WallThickness = 2.0; //Changed for SpacerJig()
DoubleLength = 2*AddWall(Length);

ScrewDiameter =  3.5;
SpacerHeight=4;

function OuterLength(l) = AddWall(l);
function AddWall(length) = length + (2*WallThickness);
function Middle(length) = length/2;
function AddWall2(length)=length + 4.0;
ScrewDiameter2 = 3.5;


spokeCount=24;
spokerows=8;
spokeDia=15;
spokeY=2;
wallWidth=2;

FootPad245();

module Manafold()
{

        for(x = [1:Seedcolumns], Y =[1:Seedrows])
        {
            difference()
            {
            translate([(CylinderWidth*(x-1))+CellPad, (CylinderWidth*(Y-1))+CellPad,0])
             color("Green")cylinder($fn=100,CylinderHeight*(Y),(Diameter1/2)+2,(Diameter2/2)+2,center=false);
            translate([(CylinderWidth*(x-1))+CellPad, (CylinderWidth*(Y-1))+CellPad,CylinderHeight*(Y-1)+SphereDiameter/2])
            color("Blue") sphere($fn=100,d=SphereDiameter, center=false);
            }
        }
        
}

module FootPad245()
{
    difference()
    {
//        translate([-Middle(DoubleLength),Middle(AddWall(Width)),12]) 
        rotate([0,180,0])
        linear_extrude(height = 24.5, center = true, convexity = 10, scale=[1,2.2559], $fn=100)
        circle(r = Diameter1,center=true);      
        
        #translate([0,0,8.5])
        cylinder($fn=100,7.8,(Diameter2/2),(Diameter1/2),center=true);
        
    }
}

module FootPad1394()
{
    difference()
    {
//        translate([-Middle(DoubleLength),Middle(AddWall(Width)),12]) 
        rotate([0,180,0])
        linear_extrude(height = 13.94, center = true, convexity = 10, scale=[1,2.2559], $fn=100)
        circle(r = Diameter1,center=true);      
        
        #translate([0,0,3.15])
        cylinder($fn=100,7.8,(Diameter2/2),(Diameter1/2),center=true);
        
    }
}