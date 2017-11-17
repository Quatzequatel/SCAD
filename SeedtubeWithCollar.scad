//Lip
LipRadiusOuter=23;
LipRadiusInner=18;
LipHeight=2;
//matrix
rows = 1;
columns = 1;
LipDiameter = LipRadiusOuter * 2;
ModelSpacing = LipRadiusOuter -20;


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

union()
{
Tube();
Lip();
}

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

module Lip()
{
    difference()
    color("Green")
    //translate([LipRadiusOuter/2,LipRadiusOuter/2,0])
    translate([(CylinderWidth*(1-1))+CellPad, (CylinderWidth*(1-1))+CellPad,0])  
    difference()
    {
    cylinder($fn=100, LipHeight, LipRadiusOuter, LipRadiusOuter, false);
    translate([0,0,-1])
    cylinder($fn=100, LipHeight+2, LipRadiusInner, LipRadiusInner, false);    
    }
    //linear_extrude(height = LipHeight+.5){translate([8,-10.5,LipHeight])text("18.1", 2);}
}    

module matrix()
{
    for(x=[1:columns], y=[1:rows])
    {
        //echo(x=x);echo(x=(ModelSpacing*(x) + (LipDiameter*(x-1)))); echo(y=0); echo();
        translate([
            ModelSpacing*(x) + (LipDiameter*(x-1)),
            ModelSpacing*(y) + (LipDiameter*(y-1)),
            0
        ])
        {
            Lip();
        }
    }
}
    
    
