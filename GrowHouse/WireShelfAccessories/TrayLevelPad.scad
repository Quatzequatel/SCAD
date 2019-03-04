RodDiameter = 4.0;
RodSpacing =16.5;

PadLength = 23.75;
PadHeight = 70;


module trayLevelPad()
{
    color("blue")difference()
    {
        difference()
        {
        cube([PadLength,PadLength,PadHeight]);
        translate([radius(),yMove(),zMove(0.5)])
        rotate(a=[-90,0,0])
        cylinder($fn=100,barLength(), radius(), radius(), false);
        }
        translate([PadLength-radius(),yMove(),zMove(0.5)])
        rotate(a=[-90,0,0])
        cylinder($fn=100,barLength(), radius(), radius(), false);
    }
}

function zMove(x=0)=PadHeight-(RodDiameter/4)-x;
function yMove(x=0)=(x==0)? -1:x;
function radius(x=RodDiameter/2)= x;
function barLength(x=PadLength +2) = x;


trayLevelPad();
