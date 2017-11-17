
CylinderWidth=40;
Seedrows=1;
Seedcolumns=1;
Thickness=2;
CylinderHeight=50;
CellSpacing=2;
CellPad=20;


spokeCount=24;
spokerows=8;
spokeDia=15;
spokeY=2;
wallWidth=2;

Tube();

module Tube()
{
    union()
    {
        for(x = [1:Seedcolumns], Y =[1:Seedrows])
        {
               //translate([(40*x), (40*Y),-1]) color("Blue") cube($fn=100,[35,35,5],center=true)
            translate([(CylinderWidth*(x-1))+CellPad, (CylinderWidth*(Y-1))+CellPad,0])  
            difference()
            {
                color("Green")cylinder($fn=100,CylinderHeight,(CylinderWidth/2)-2,(CylinderWidth/2)-2,center=false);
                translate(0,0,10) cylinder($fn=100,CylinderHeight+2,((CylinderWidth/2)) - (wallWidth+CellSpacing),((CylinderWidth/2))-(wallWidth+CellSpacing),center=false);
            }
        }
    }
}
