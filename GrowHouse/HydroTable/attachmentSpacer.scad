Width = 18.50;
Length = Width;
ScrewDiameter = 7.9;
SpacerWidth = 15.6; //Changed for SpacerJig()
SpacerLength=Double(SpacerWidth);
SpacerHeight=6;
WallThickness = (2.0); //Changed for SpacerJig()
function AddWall(length) = length + 4;
function Middle(length) = length/2;
function Double(value) = value*2;

module attachmentSpacer()
{
    difference()
    {

        cube([15.6, SpacerLength,SpacerHeight]);
        //translate(0,0,5)
        translate([Middle(SpacerWidth), Middle(SpacerLength),1])
            cylinder($fn=100,h=8,d1=ScrewDiameter,d2=ScrewDiameter,center=false);
    }
}

attachmentSpacer();