RodDiameter = 4.0;
RodSpacing =16.5;

PadLength = 23.75;
PadHeight = 20;


module trayLevelPad()
{
    color("blue")difference()
    {
        difference()
        {
        cube([PadLength,PadLength,PadHeight]);
        translate([(RodDiameter/2),-1,PadHeight-(RodDiameter/4)])
        rotate(a=[-90,0,0])
        cylinder($fn=100,PadLength +2, RodDiameter/2, RodDiameter/2, false);
        }
        translate([PadLength-(RodDiameter/2),-1,PadHeight-(RodDiameter/4)])
        rotate(a=[-90,0,0])
        cylinder($fn=100,PadLength +2, RodDiameter/2, RodDiameter/2, false);
    }
}

trayLevelPad();
