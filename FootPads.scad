
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


spokeCount=24;
spokerows=8;
spokeDia=15;
spokeY=2;
wallWidth=2;

Manafold();

module Manafold()
{

        for(x = [1:Seedcolumns], Y =[1:Seedrows])
        {
            difference()
            {
            translate([(CylinderWidth*(x-1))+CellPad, (CylinderWidth*(Y-1))+CellPad,0])
             color("Green")cylinder($fn=100,CylinderHeight*(Y),(CylinderWidth/2)-2,(CylinderWidth/2)-2,center=false);
            translate([(CylinderWidth*(x-1))+CellPad, (CylinderWidth*(Y-1))+CellPad,CylinderHeight*(Y-1)+SphereDiameter/2])
            color("Blue") sphere($fn=100,d=SphereDiameter, center=false);
            }
        }
        
}
