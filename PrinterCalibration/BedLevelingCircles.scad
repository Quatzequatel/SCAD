
PadOD = 100;

LayerHeight = 0.4;
NozzleWidth = 0.8;
LineCount = 6;
PadWidth = NozzleWidth * LineCount;

PadHeight = 0.8;
// PadWidth = 20;
PrintBedX = 190 - PadWidth - PadOD;
printBedY = 190 - PadWidth - PadOD;
xFactor = [0,1,-1,1,-1];
yFactor = [0,1,1,-1,-1];
// function xFactor(i) = lookup(i, [0,1,-1,1,-1]);
// function yFactor(i) = lookup(i, [0,1,1,-1,-1]);
$fn = 260;

Build("single");
module Build(arg)
{
    if(arg == "single")
    {
        PadCreate(PadOD, PadOD - PadWidth, PadHeight, 0, 0);
    }
    else
    {
        PrintBedLevelingCircles();
    }
}

module PrintBedLevelingCircles()
{
    for (i=[0:4]) 
    {
        echo(i=i, x=xFactor[i], y= yFactor[i]);
        PadCreate(PadOD, id = 0, PadHeight, xFactor[i] * PrintBedX, yFactor[i] * printBedY);
    }
}

module PadCreate(od, id = 0, height, x=0, y=0, z=0) 
{
    echo("PadCreate", dia=od, height=height, x=x, y=y, z=z);
    translate([ x, y, z]) {
        linear_extrude(height =height)
        difference()
        {
            circle(d=od);        
            circle(d = id);

        }
    }
}