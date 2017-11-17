//Lip
LipRadiusOuter=23;
LipRadiusInner=18.1;
LipHeight=2;
//matrix
rows = 1;
columns = 1;
LipDiameter = LipRadiusOuter * 2;
ModelSpacing = LipRadiusOuter -20;

module Lip()
{
    difference()
    color("Green")
    translate([LipRadiusOuter/2,LipRadiusOuter/2,0])
    difference()
    {
    cylinder($fn=100, LipHeight, LipRadiusOuter, LipRadiusOuter, false);
    translate([0,0,-1])
    cylinder($fn=100, LipHeight+2, LipRadiusInner, LipRadiusInner, false);    
    }
    linear_extrude(height = LipHeight+.5){translate([8,-10.5,LipHeight])text("18.1", 2);}
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
    
    
matrix();    