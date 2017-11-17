
meshX=26;
meshY=18;
meshZ=40;
CylinderWidth=40;
Seedrows=3;
Seedcolumns=3;
Thickness=2;
CylinderHeight=2;
CellSpacing=2;
CellPad=20;

cubeWidth = 15;
cubeHeight = 64;



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
            cube([cubeWidth,cubeWidth,cubeHeight], false);
            translate([(CylinderWidth*(x-1))+CellPad+ (cubeWidth/2), (CylinderWidth*(Y-1))+CellPad + (cubeWidth/2),cubeHeight - 12])
             color("Green")cylinder($fn=100,14,1.5,1.5,center=false);
            }
        }
        
}
