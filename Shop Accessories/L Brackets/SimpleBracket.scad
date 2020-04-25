/*

*/
$fn=24;
NozzleWidth = 1.0;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
mmPerInch = 25.4;
wallCount = 2;

function InchTomm(inches = 1) = inches * mmPerInch;
function height2layers(mm = 1) = mm/LayerHeight;
function layers2Height(layers) = InitialLayerHeight + ((layers - 1) * LayerHeight);
function BaseHeight() = layers2Height(6);
function WallThickness(count) = count * NozzleWidth;
Height = InchTomm(2);
BracketThickness = 6;
BracketWidth = mmPerInch + BracketThickness;
ScrewHoleRadius = 2;
ScrewHoleCount = 3;
ScrewHoleOffsetZ = Height / ScrewHoleCount;
ScrewHoleOffsetX = BracketWidth / 2;
ScrewHoleOffsetY = BracketWidth / 2;

LbracketPoints = 
[
    [0,0], 
    [BracketWidth,0], 
    [BracketWidth, BracketThickness], 
    [BracketThickness,BracketThickness], 
    [BracketThickness, BracketWidth], 
    [0, BracketWidth]];

Build();



module Build(args) 
{
    difference()
    {
        linear_extrude(height=Height, center=false, convexity=10, twist=0) 
        {
            polygon(points=LbracketPoints);        
        }
        screwHolesY();
        screwHolesX();        
    }

}

module screwHolesY()
{
    for(i = [0 : ScrewHoleCount - 1])
    {
        translate([BracketThickness-2, ScrewHoleOffsetY+5, ScrewHoleOffsetZ * i  + ScrewHoleOffsetZ/2]) 
        rotate([0, 90, 0]) 
        cylinder(r=ScrewHoleRadius, h= 2 * BracketThickness, center=true);
    }
    
}

module screwHolesX()
{
    for(i = [0 : ScrewHoleCount - 1])
    {
        translate([ScrewHoleOffsetX+5, BracketThickness-2,  ScrewHoleOffsetZ * i  + ScrewHoleOffsetZ/2]) 
        rotate([90, 0, 0]) 
        cylinder(r=ScrewHoleRadius, h= 2 * BracketThickness, center=true);
    }
    
}
