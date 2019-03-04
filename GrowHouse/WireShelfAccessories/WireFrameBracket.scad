TopOutDiameter = 34.24;
BottomOutDiameter = 36;

TopInsideDiameter = 29.25;
BottomInsideDiameter = 31.3;

Height = 40;

module WireFrameBracket()
{
    translate([BottomOutDiameter/2,BottomOutDiameter/2,0])
    difference()
    {
    cylinder($fn = 360,  Height, BottomOutDiameter/2, TopOutDiameter/2, false);
    cylinder($fn = 360,  Height, BottomInsideDiameter/2, TopInsideDiameter/2, false);
    
    }
}

WireFrameBracket();